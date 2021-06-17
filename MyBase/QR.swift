// swiftlint:disable type_name
//
//  QR.swift
//  MyBase
//
//  Created by Harvey on 2020/1/6.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import CoreImage
import UIKit

extension UIColor {
    
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
}

public class QR {
    
    /// 容错级别
    enum Level: CGFloat {
        /// L 7%
        case low = 0.07
        /// M 15%
        case middle = 0.15
        /// Q 25%
        case quantity = 0.25
        /// H 30%
        case high = 0.3
    }
    
    public struct Model {
        
        /// 文本
        public var text: String
        
        /// 二维码中间的logo
        public var logo: String?
        
        /// 二维码缩放倍数 size = CGSize(width: 27.0  * scale, height: 27.0 * scale)
        public var scale: Float
        
        /// 二维码背景颜色
        public var backgroundColor: UIColor = .white
        
        /// 二维码颜色
        public var contentColor: UIColor = .black
        
        /// 容错级别
        fileprivate var level: Level = .low
        
        public init(text: String, scale: Float = 10.0, logo: String? = nil) {
            
            self.text = text
            self.scale = scale
            self.logo = logo
        }
    }
    
    static let shared = QR()
    
    private let qrFilter: CIFilter
    private let colorFilter: CIFilter
    
    private init() {
        
        /// 创建二维码滤镜
        qrFilter = CIFilter(name: "CIQRCodeGenerator")!
        
        /// 创建颜色滤镜
        colorFilter = CIFilter(name: "CIFalseColor")!
    }
    
    private func createBase(text: String, scale: Float, _ encoding: String.Encoding = .utf8) -> CIImage? {
        
        qrFilter.setDefaults()
        guard let data = text.data(using: encoding) else {
            return nil
        }
        
        /// 给二维码滤镜设置inputMessage
        qrFilter.setValue(data, forKey: "inputMessage")
        guard var outputImage = qrFilter.outputImage else {
            return nil
        }
        
        outputImage = outputImage.transformed(by: CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale)))
        return outputImage
    }
    
    private func colourFilter(ciImage: CIImage, model: QR.Model) -> CIImage? {
        
        /// 颜色滤镜恢复默认值
        colorFilter.setDefaults()
        
        /// 设置颜色滤镜的inputImage
        colorFilter.setValue(ciImage, forKey: "inputImage")
        
        /// 设置inputImage的backgroundColor(key: inputColor1)
        colorFilter.setValue(model.backgroundColor.coreImageColor, forKey: "inputColor1")
        
        /// 设置inputImage的contentColor(key: inputColor0)
        colorFilter.setValue(model.contentColor.coreImageColor, forKey: "inputColor0")
        
        return colorFilter.outputImage
    }
    
    private func addLogo(ciImage: CIImage, model: QR.Model) -> UIImage? {
        
        guard let _ = model.logo, let logoImage = UIImage(named: model.logo!) else {
            return nil
        }
        
        let image = UIImage(ciImage: ciImage)
        let faultyRate = logoImage.size.area / image.size.area
        let maxArea = floor(Double(image.size.area * model.level.rawValue))
        
        /// 容错率判断
        if faultyRate > model.level.rawValue {
            puts("logo太大，已超过二维码最大容错率", "根据当前设置，logo的 (宽 * 高) 不能大于 \(maxArea)")
            return nil
        }
            
        puts("二维码容错率: \(faultyRate)%")
        let originX = (image.size.width - logoImage.size.width) / 2.0
        let originY = (image.size.height - logoImage.size.height) / 2.0
        
        UIGraphicsBeginImageContextWithOptions(image.size, true, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        logoImage.draw(in: CGRect(x: originX, y: originY, width: logoImage.size.width, height: logoImage.size.height))
        
        let outPutImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outPutImage
    }
    
    private func create(_ model: QR.Model) -> UIImage? {
        
        guard var outputImage = createBase(text: model.text, scale: model.scale) else {
            return nil
        }
        
        if let colorOutputImage = colourFilter(ciImage: outputImage, model: model) {
            outputImage = colorOutputImage
        }
        
        guard let qrImageWithLogo = addLogo(ciImage: outputImage, model: model) else {
            return UIImage(ciImage: outputImage)
        }
        
        return qrImageWithLogo
    }
    
    public static func create(_ model: QR.Model) -> UIImage? {
        return shared.create(model)
    }
}

extension CGSize {
    
    /// 面积 S
    var area: CGFloat {
        width * height
    }
}

extension UIImage {
    
    /// Read message from QR Image
    public var qrMessage: String? {
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else {
            return nil
        }
        if ciImage == nil, cgImage == nil {
            return nil
        }
        let ciImage: CIImage = self.ciImage == nil ? CIImage(cgImage: self.cgImage!) : self.ciImage!
        let features = detector.features(in: ciImage)
        guard let feature = features.first as? CIQRCodeFeature else { return nil }
        return feature.messageString
    }
}

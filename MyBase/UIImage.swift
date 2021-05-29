//
//  UIImage.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import UIKit

// MARK: - Extension UIImage
extension UIImage {

    /// 将 GIF 文件 解析成 UIImage
    /// - Parameter named: gif 文件名称，不包括后缀 `.gif`
    /// - Returns: 元组
    public static func parseGIF(_ named: String) -> (images: [UIImage], duration: TimeInterval) {
        
        guard let url = App.Bundle.url(named, "gif") else { return ([], 0.0) }
        guard let data = try? Data.init(contentsOf: url) else { return ([], 0.0) }
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return ([], 0.0) }
        
        var images: [UIImage] = []
        var totalDuration: TimeInterval = 0.0
        let imageCount: Int = CGImageSourceGetCount(imageSource)

        for index in 0..<imageCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, index, nil) else { continue  }
            images.append(UIImage(cgImage: cgImage))
            
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil) else { continue }
            // swiftlint:disable:next line_length
            guard let propertyGIF = (properties as? [String: Any])?[kCGImagePropertyGIFDictionary as String] as? [String: Any] else { continue }
            guard let duration = propertyGIF[kCGImagePropertyGIFDelayTime as String] as? TimeInterval else { continue }
            
            totalDuration += duration
        }
       
        return (images, totalDuration)
    }
    
    /// 转为 UIColor
    public var color: UIColor {
        UIColor(patternImage: self)
    }
}

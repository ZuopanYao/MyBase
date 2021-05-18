//
//  UIColor.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import UIKit

// MARK: - Extension UIKit - UIColor
extension UIColor {
    
    /// 颜色实例
    /// - Parameters:
    ///   - red: 范围 [0, 255]
    ///   - green: 范围 [0, 255]
    ///   - blue: 范围 [0, 255]
    ///   - alpha: 范围 [0.0, 1.0], 默认 1.0
    public convenience init(red: UInt, green: UInt, blue: UInt, alpha: Float = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
        
    /// 灰阶
    /// - Parameters:
    ///   - level: 范围 [0, 255]
    ///   - alpha: 不透明度，范围 [0.0, 1.0], 默认为 1.0
    /// - Returns: UIColor
    public static func gray(_ level: UInt, alpha: Float = 1.0) -> UIColor {
        return UIColor(red: level, green: level, blue: level, alpha: alpha)
    }
    
    /// 十六进制颜色 e.g. 0xFFFF99
    /// - Parameters:
    ///   - value: 十六进制颜色
    ///   - alpha: 不透明度，范围 [0.0, 1.0], 默认为 1.0
    public convenience init(hex value: UInt, alpha: Float = 1.0) {
        
        let red = (value & 0xFF0000) >> 16
        let green = (value & 0x00FF00) >> 8
        let blue = value & 0x0000FF
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

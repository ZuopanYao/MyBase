//
//  Global.swift
//  
//
//  Created by Harvey on 2021/4/27.
//

import UIKit

/// 全局参数
public struct Global {
    
    /// 屏幕的 Size
    public static var size: CGSize { UIScreen.main.bounds.size }

    /// 屏幕的宽度
    public static var width: CGFloat { size.width }
    
    /// 屏幕的高度
    public static var height: CGFloat { size.height }
    
    /// 如果是 iPad
    public static let isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    /// true = 刘海屏
    public static let isNotchScreen: Bool = {
        if isPad { return false }
        let size = UIScreen.main.bounds.size
        let notchValue: Int = Int(size.width/size.height * 100)
        if 216 == notchValue || 46 == notchValue { return true }
        return false
    }()
    
    /// true = 黑暗模式
    public static var isDark: Bool {
        guard #available(iOS 13.0, *) else { return false }
        return UITraitCollection.current.userInterfaceStyle == .dark
    }
}

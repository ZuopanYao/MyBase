//
//  Global.swift
//  FreeVPN
//
//  Created by Harvey on 2021/4/27.
//

import UIKit

/// 全局参数
public struct Global {
    
    /// 屏幕的 Size
    public static let size = UIScreen.main.bounds.size

    /// 屏幕的宽度
    public static let width = size.width
    
    /// 屏幕的高度
    public static let height = size.height
    
    /// 如果是 iPad
    public static let isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    /// true = 刘海屏
    public static let isNotchScreen: Bool = {
        guard let keyWindow = App.shared.keyWindow else {
            return false
        }
        return keyWindow.safeAreaInsets.bottom > 0
    }()
    
    /// true = 黑暗模式
    public static var isDark: Bool {
        guard #available(iOS 13.0, *) else { return false }
        return UITraitCollection.current.userInterfaceStyle == .dark
    }
}

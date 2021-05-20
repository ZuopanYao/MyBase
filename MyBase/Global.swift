//
//  Global.swift
//  FreeVPN
//
//  Created by Harvey on 2021/4/27.
//

import UIKit

/// 全局参数
struct Global {
    
    /// 屏幕的 Size
    static let size = UIScreen.main.bounds.size

    /// 屏幕的宽度
    static let width = size.width
    
    /// 屏幕的高度
    static let height = size.height
    
    /// 如果是 iPad
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    /// true = 刘海屏
    static let isNotchScreen: Bool = {
        guard let keyWindow = App.shared.keyWindow else {
            return false
        }
        return keyWindow.safeAreaInsets.bottom > 0
    }()
    
    /// true = 黑暗模式
    static var isDark: Bool {
        guard #available(iOS 13.0, *) else { return false }
        return UITraitCollection.current.userInterfaceStyle == .dark
    }
}

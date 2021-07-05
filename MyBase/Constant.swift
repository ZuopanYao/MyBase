//
//  Constant.swift
//  
//
//  Created by Harvey on 2021/4/27.
//

import UIKit

/// 全局参数
public protocol Constant {
    
}

public extension Constant {
    
    /// 屏幕的 Size
    static var size: CGSize { UIScreen.main.bounds.size }

    /// 屏幕的宽度
    static var width: CGFloat { size.width }
    
    /// 屏幕的高度
    static var height: CGFloat { size.height }
    
    /// true = It's iPad
    static var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }
    
    /// true = It's iPhone
    static var isPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }

    /// 状态栏高度
    static var statusBarHeight: CGFloat { App.shared.statusBarFrame.height }
    
    /// 导航栏高度
    static var navigationBarHeight: CGFloat {
        guard isPhone else { return 50.0 }
        guard App.shared.statusBarOrientation.isLandscape else {
            return 44.0
        }
        return 32.0
    }
    
    /// 标签栏高度
    /// iPad Pro 11.0 第一代(2018年)开始，标签栏高度为 65.0
    /// iPad Pro 12.9 第三代(2018年)开始，标签栏高度为 65.0
    static var tabBarHeight: CGFloat {
        guard isPhone else { return 50.0 }
        guard App.shared.statusBarOrientation.isLandscape else {
            return isNotchScreen ? 50.0 : 49.0
        }
        return 32.0
    }
    
    /// 底部安全区域高度
    static var safeAreaHeightOfBottom: CGFloat {
        guard let keyWindow = App.shared.keyWindow else {
            return App.shared.windows.first!.safeAreaInsets.bottom
        }
        return keyWindow.safeAreaInsets.bottom
    }

    /// true = 刘海屏
    static var isNotchScreen: Bool {
        guard isPhone else { return false }
        let size = UIScreen.main.bounds.size
        let notchValue: Int = Int(size.width / size.height * 100)
        if 216 == notchValue || 46 == notchValue { return true }
        return false
    }
    
    /// true = 黑暗模式
    static var isDark: Bool {
        guard #available(iOS 13.0, *) else { return false }
        return UITraitCollection.current.userInterfaceStyle == .dark
    }
}

//
//  UIImageView.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import UIKit

// MARK: - Extension UIImageView
extension UIImageView {
    
    /// 加载 GIF 并开始动画
    /// - Parameter named: GIF名称(不包含扩展名 `.gif`)
    public func loadGIF(_ named: String) {
        let gif = UIImage.parseGIF(named)
        animationImages = gif.images
        animationDuration = gif.duration
        startAnimating()
    }
    
    /// 设置图片
    public var imageNamed: String? {
        get { nil }
        set {
            guard let newValue = newValue else { return }
            image = newValue.image
        }
    }
    
}

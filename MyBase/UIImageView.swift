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
        let git = UIImage.parseGIF(named)
        animationImages = git.images
        animationDuration = git.duration
        startAnimating()
    }
}

//
//  UIView.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import UIKit

// MARK: - Extension UIKit - UIView
extension UIView {
    
    /// 点击事件
    public func tap(target: Any?, action: Selector?) {
        if isKind(of: UIButton.self) {
            (self as! UIButton).addTarget(target, action: action!, for: .touchUpInside)
            return
        }
        
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tap)
    }
    
    private struct LongPress {
        static var store: [NSObject: (target: Any, action: Selector, isCanCall: Bool)] = [:]
    }
    
    /// 长按事件
    /// - Parameters:
    ///   - target: Any
    ///   - action: 事件
    ///   - duration: 按多长时间触发, 默认 0.5, 单位： 秒
    public func longTap(target: Any, action: Selector, duration: TimeInterval = 0.5) {
        LongPress.store[self] = (target, action, true)
        isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = duration
        addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
        let longTap = LongPress.store[self]!
        if longTap.isCanCall {
            LongPress.store[self]!.isCanCall = false
            typealias Call = @convention(c) (Any, Selector, UILongPressGestureRecognizer) -> Void
            let method = class_getInstanceMethod(object_getClass(longTap.target), longTap.action)!
            let imp = method_getImplementation(method)
            let call = unsafeBitCast(imp, to: Call.self)
            call(longTap.target, longTap.action, longPress)
        }
        switch longPress.state {
        case .ended: LongPress.store[self]!.isCanCall = true
        default: break
        }
    }
    
    // swiftlint:disable:next identifier_name
    public var x: CGFloat {
        get { frame.origin.x }
        set { frame = CGRect(origin: CGPoint(x: newValue, y: frame.origin.y), size: frame.size) }
    }
    
    // swiftlint:disable:next identifier_name
    public var y: CGFloat {
        get { frame.origin.y }
        set { frame = CGRect(origin: CGPoint(x: frame.origin.x, y: newValue), size: frame.size) }
    }
    
    public var width: CGFloat {
        get { frame.size.width }
        set { frame = CGRect(origin: frame.origin, size: CGSize(width: newValue, height: frame.size.height)) }
    }
    
    public var height: CGFloat {
        get { frame.size.height }
        set { frame = CGRect(origin: frame.origin, size: CGSize(width: frame.size.width, height: newValue)) }
    }
    
    /// 设置圆角
    ///
    /// # Parameters
    ///
    /// 1. radius: 半径，这是必须的
    /// 2. masksToBounds: 是否将子层裁剪到父层边界，保持默认，可传 nil
    ///
    /// # Example
    ///
    ///     let view = UIView()
    ///     view.corner = (50.0, nil)
    ///     // view.corner = (50.0, true)
    public var corner: (radius: CGFloat, masksToBounds: Bool?) {
        get { (layer.cornerRadius, layer.masksToBounds) }
        set {
            layer.cornerRadius = newValue.radius
            if let masksToBounds = newValue.masksToBounds { layer.masksToBounds = masksToBounds }
        }
    }
    
    /// 设置边框
    ///
    /// # Parameters
    ///
    /// 1. width: 宽度
    /// 2. color: 颜色, 保持默认，可传 nil
    ///
    /// # Example
    ///
    ///     let view = UIView()
    ///     view.border = (50.0, nil)
    ///     // view.border = (50.0, UIColor.red.cgColor)
    public var border: (width: CGFloat, color: CGColor?) {
        get { (layer.borderWidth, layer.borderColor) }
        set {
            layer.borderWidth = newValue.width
            layer.borderColor = newValue.color
        }
    }
    
    /// 设置阴影
    ///
    /// # Parameters
    ///
    /// 1. color: 颜色, 保持默认，可传 nil
    /// 2. offset: 偏移, 保持默认，可传 nil
    /// 3. radius: 圆角半径, 保持默认，可传 nil
    /// 4. opacity: 透明度，这是必须的
    ///
    /// # Example
    ///
    ///     let view = UIView()
    ///     view.shadow = (UIColor.red.cgColor, .zero, 10.0, 1.0)
    public var shadow: (color: CGColor?, offset: CGSize?, radius: CGFloat?, opacity: Float) {
        get { (layer.shadowColor, layer.shadowOffset, layer.shadowRadius, layer.shadowOpacity) }
        set {
            layer.shadowColor = newValue.color
            layer.shadowOpacity = newValue.opacity
            if let offset = newValue.offset { layer.shadowOffset = offset }
            if let radius = newValue.radius { layer.shadowRadius = radius }
        }
    }
}

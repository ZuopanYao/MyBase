//
//  UIView.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import UIKit
import RxSwift
import RxCocoa

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
        static var store: [NSObject: (call: () -> Void, isCanCall: Bool)] = [:]
    }
    
    /// 长按事件
    /// - Parameters:
    ///   - duration: 按下多长时间触发，默认 0.5, 单位： 秒
    ///   - touches: 按下手指个数，默认 1
    ///   - closure: 事件
    public func longPress(duration: TimeInterval = 0.5, touches: Int = 1, closure: @escaping () -> Void) {
        LongPress.store[self] = (closure, true)
        isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = duration
        longPress.numberOfTouchesRequired = touches
        addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
        if LongPress.store[self]!.isCanCall {
            LongPress.store[self]!.isCanCall = false
            LongPress.store[self]!.call()
        }
        switch longPress.state {
        case .ended: LongPress.store[self]!.isCanCall = true
        default: break
        }
    }
    
    public var x: CGFloat {
        // swiftlint:disable:previous identifier_name
        get { frame.origin.x }
        set { frame = CGRect(origin: CGPoint(x: newValue, y: frame.origin.y), size: frame.size) }
    }
    
    public var y: CGFloat {
        // swiftlint:disable:previous identifier_name
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
    public var border: (width: CGFloat, color: UIColor?) {
        get { (layer.borderWidth, layer.borderColor.map { UIColor(cgColor: $0) }) }
        set {
            layer.borderWidth = newValue.width
            layer.borderColor = newValue.color?.cgColor
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
    public var shadow: (color: UIColor?, offset: CGSize?, radius: CGFloat?, opacity: Float) {
        get { (layer.shadowColor.map { UIColor(cgColor: $0) }, layer.shadowOffset, layer.shadowRadius, layer.shadowOpacity) }
        set {
            layer.shadowColor = newValue.color?.cgColor
            layer.shadowOpacity = newValue.opacity
            if let offset = newValue.offset { layer.shadowOffset = offset }
            if let radius = newValue.radius { layer.shadowRadius = radius }
        }
    }
}

private let actionSubject: PublishSubject<NSObject> = .init()
private let disposeBag: DisposeBag = .init()
private var registerStore: [Weakly] = []

public protocol RxAction { }

extension RxAction where Self: UIView {
    
    /// 语法糖 - 点击事件
    public var click: ((RxSwift.Event<Self>) -> Void)? {
        get { nil }
        set {
            registerStore = registerStore.strongReference()
            if registerStore.contains(self) {
                return
            }
            registerStore.append(Weakly(self))
            
            if self.isKind(of: UIButton.self) {
                (self as! UIButton).rx.tap
                    .map { self }
                    .subscribe(newValue!)
                    .disposed(by: disposeBag)
                return
            }
            
            isUserInteractionEnabled = true
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapWithCall(sender:))))
            
            actionSubject
                .filter { $0 == self }
                .compactMap { $0 as? Self }
                .subscribe(newValue!).disposed(by: disposeBag)
        }
    }
}

extension UIView {
    
    @objc fileprivate func tapWithCall(sender: UITapGestureRecognizer) {
        actionSubject.onNext(self)
    }
}

extension NSObject: RxAction { }

extension UIView {
    
    /// Snapshot 对已显示在屏幕上的内容进行截图快照
    public var snapshot: UIImage? {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIView {
    
    public typealias LineData = (start: CGPoint, end: CGPoint)
    
    public struct DrawConfig {
        public typealias DashPattern = (dotWidth: CGFloat, dotSpacing: CGFloat)
        
        public var fillColor: UIColor
        public var strokeColor: UIColor?
        public var lineWidth: CGFloat
        public var fillRule: CAShapeLayerFillRule
        public var lineCap: CAShapeLayerLineCap
        public var lineJoin: CAShapeLayerLineJoin
        public var lineDashPattern: DashPattern?
        
        public init(fillColor: UIColor = .black, 
                    strokeColor: UIColor? = nil,
                    lineWidth: CGFloat = 1.0,
                    fillRule: CAShapeLayerFillRule = .nonZero,
                    lineCap: CAShapeLayerLineCap = .butt,
                    lineJoin: CAShapeLayerLineJoin = .round,
                    lineDashPattern: DashPattern? = nil) {
            self.fillColor = fillColor
            self.strokeColor = strokeColor
            self.lineWidth = lineWidth
            self.fillRule = fillRule
            self.lineCap = lineCap
            self.lineJoin = lineJoin
            self.lineDashPattern = lineDashPattern
        }
        
        var dashPattern: [NSNumber]? {
            guard let lineDashPattern = lineDashPattern else { return nil }
            return [NSNumber(value: lineDashPattern.dotWidth), NSNumber(value: lineDashPattern.dotSpacing)]
        }
        
        public static let `default` = DrawConfig()
    }
    
    /// 画线
    public func drawLines(_ lineDatas: [LineData], config: DrawConfig) {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = config.lineWidth
        shapeLayer.lineJoin = config.lineJoin
        shapeLayer.lineCap = config.lineCap
        shapeLayer.lineDashPattern = config.dashPattern
        
        shapeLayer.fillRule = config.fillRule
        shapeLayer.fillColor = config.fillColor.cgColor
        shapeLayer.strokeColor = config.strokeColor?.cgColor
        
        // 设置绘制的路径
        let path = UIBezierPath()
        lineDatas.forEach { (start: CGPoint, end: CGPoint) in
            path.move(to: start)
            path.addLine(to: end)
        }
        
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
    }
}

extension UIView {
    
    /// 添加遮罩
    ///
    /// - Parameters:
    ///   - frame: 遮罩在父视图的位置
    ///   - bgColor: 遮罩背景颜色
    ///   - hollowRect: 留出镂空区域，在遮罩中的位置
    public func addShade(
        _ frame: CGRect = UIScreen.main.bounds,
        bgColor: UIColor = UIColor.black.withAlphaComponent(0.2),
        hollowRect: CGRect) {
            
            let rect = CGRect(origin: .zero, size: frame.size)
            let maskView = UIView(frame: frame)
            maskView.mask = UIView(frame: rect)
            maskView.backgroundColor = bgColor
            addSubview(maskView)
            
            let maskLayer = CAShapeLayer()
            maskLayer.fillRule = .evenOdd
            maskView.mask?.layer.addSublayer(maskLayer)
            
            let path = CGMutablePath(rect: rect, transform: .none)
            path.addRect(hollowRect)
            maskLayer.path = path
        }
}

//
//  RxView.swift
//
//
//  Created by Harvey on 2023/10/28.
//

import UIKit
import RxSwift
import RxCocoa

public typealias ControlTapGesture = Observable<Void>

extension Reactive where Base: UIView {

    public var tapEvent: ControlTapGesture {
        if self.base.isKind(of: UIButton.self) {
            fatalError("UIButton: Use `rx.tap` please.")
        }
        return controlTapGesture()
    }
    
    public func controlTapGesture() -> ControlTapGesture {
        return Observable.create { [weak control = self.base] observer in
            MainScheduler.ensureRunningOnMainThread()
            
            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            let controlTapGesture = RXControlTapGesture(control) {
                observer.on(.next(()))
            }
            return Disposables.create(with: controlTapGesture.dispose)
        }
    }
}

class RXControlTapGesture: Disposable {

    private var view: UIView
    private var callBack: () -> Void
    
    init(_ view: UIView, callBack: @escaping () -> Void) {

        self.view = view
        self.callBack = callBack
        
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer)))
    }
    
    @objc private func tapGestureRecognizer() {
        callBack()
    }
    
    func dispose() { }
}

//
//  Sugar.swift
//  MyBase
//
//  Created by Harvey on 2021/5/19.
//

import UIKit
import ElegantSnap
import SnapKit

/// 语法糖
public protocol Sugar { }

extension Sugar where Self: Any {
    
    @inlinable public func with(sugar: (inout Self) throws -> Void) rethrows -> Self {
       var copySelf = self
       try sugar(&copySelf)
       return copySelf
     }
}

extension Sugar where Self: NSObject {
    
    @inlinable public func `do`(sugar: (Self) throws -> Void) rethrows {
      try sugar(self)
    }
    
    /// .init() 实例化
    @inlinable public static func `do`(sugar: (Self) throws -> Void) rethrows {
        let instance = Self.init()
        try sugar(instance)
    }
    
    /// 指定构造方法实例化方法
    @inlinable public static func `do`(_ instance: Self, sugar: (Self) throws -> Void) rethrows {
        try sugar(instance)
    }
    
    /// .init() 实例化, 带返回值
    @inlinable public static func then(sugar: (Self) throws -> Void) rethrows -> Self {
        let instance = Self.init()
        try sugar(instance)
        return instance
    }
    
    /// 指定构造方法实例化方法, 带返回值
    @inlinable public static func then(_ instance: Self, sugar: (Self) throws -> Void) rethrows -> Self {
        try sugar(instance)
        return instance
    }
}

extension Sugar where Self: UIView {
    
    /// 添加约束
    @inlinable public func make(sugar: (ConstraintMaker) -> Void) {
        snp.makeConstraints(sugar)
    }
    
    /// 添加约束, 带返回值
    @inlinable public func thenMake(sugar: (ConstraintMaker) -> Void) -> Self {
        snp.makeConstraints(sugar)
        return self
    }
    
    /// 添加约束
    @inlinable public func make(_ superview: UIView, sugar: (ConstraintMaker) -> Void) {
        superview.addSubview(self)
        snp.makeConstraints(sugar)
    }
    
    /// 添加约束, 带返回值
    @inlinable public func thenMake(_ superview: UIView, sugar: (ConstraintMaker) -> Void) -> Self {
        superview.addSubview(self)
        snp.makeConstraints(sugar)
        return self
    }
    
    /// 链式添加约束
    @inlinable public func makeChian(_ sugar: (ElegantSnap) -> Void) {
        make(sugar)
    }
    
    /// 链式添加约束, 带返回值
    @inlinable public func thenMakeChian(_ sugar: (ElegantSnap) -> Void) -> Self {
        make(sugar)
        return self
    }
    
    /// 链式添加约束
    @inlinable public func makeChian(_ superview: UIView, sugar: (ElegantSnap) -> Void) {
        superview.addSubview(self)
        make(sugar)
    }
    
    /// 链式添加约束, 带返回值
    @inlinable public func thenMakeChian(_ superview: UIView, sugar: (ElegantSnap) -> Void) -> Self {
        superview.addSubview(self)
        make(sugar)
        return self
    }
}

extension CGRect: Sugar { }
extension CGSize: Sugar { }
extension CGPoint: Sugar { }
extension NSObject: Sugar { }
extension CGVector: Sugar { }
extension UIOffset: Sugar { }
extension UIEdgeInsets: Sugar { }
extension NSDirectionalEdgeInsets: Sugar { }

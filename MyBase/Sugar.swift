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
    
    @inlinable public mutating func `do`(sugar: (inout Self) throws -> Void) rethrows {
      try sugar(&self)
    }
    
    @inlinable public func `do`<T: NSObject>(sugar: (inout Self) throws -> T) rethrows -> T {
        var instance = self
      return try sugar(&instance)
    }
    
    /// .init() 实例化
    @inlinable public static func then(sugar: (inout Self) throws -> Void) rethrows -> Self {
        var instance = Self.init()
        try sugar(&instance)
        return instance
    }
    
    /// 指定构造方法实例化方法
    @inlinable public static func then(_ instance: Self, sugar: (inout Self) throws -> Void) rethrows -> Self {
        var instance = instance
        try sugar(&instance)
        return instance
    }
    
    @inlinable public func immutable() -> Self {
        return self
    }
    
    @inlinable public func end() { }
}

extension Sugar where Self: UIView {
    
    /// 添加约束
    @inlinable public func make(sugar: (ConstraintMaker) -> Void) -> Self {
        snp.makeConstraints(sugar)
        return self
    }
    
    /// 添加约束
    @inlinable public func make(_ superview: UIView, sugar: (ConstraintMaker) -> Void) -> Self {
        superview.addSubview(self)
        snp.makeConstraints(sugar)
        return self
    }
    
    /// 链式添加约束
    @inlinable public func makeChian(_ sugar: (ElegantSnap) -> Void) -> Self {
        make(sugar)
        return self
    }
    
    /// 链式添加约束
    @inlinable public func makeChian(_ superview: UIView, sugar: (ElegantSnap) -> Void) -> Self {
        superview.addSubview(self)
        make(sugar)
        return self
    }
    
    @inlinable public func with<V: UIView>(sugar: (Self) throws -> V) rethrows -> V {
       return try sugar(self)
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

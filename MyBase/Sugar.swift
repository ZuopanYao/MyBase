//
//  Sugar.swift
//  MyBase
//
//  Created by Harvey on 2021/5/19.
//

import UIKit

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
    
    /// .init() 实例化, 无返回值
    @inlinable public static func `do`(sugar: (Self) throws -> Void) rethrows {
        let instance = Self.init()
        try sugar(instance)
    }
    
    /// 指定构造方法实例化方法, 无返回值
    @inlinable public static func `do`(_ instance: Self, sugar: (Self) throws -> Void) rethrows {
        try sugar(instance)
    }
    
    /// .init() 实例化
    @inlinable public static func then(sugar: (Self) throws -> Void) rethrows -> Self {
        let instance = Self.init()
        try sugar(instance)
        return instance
    }
    
    /// 指定构造方法实例化方法
    @inlinable public static func then(_ instance: Self, sugar: (Self) throws -> Void) rethrows -> Self {
        try sugar(instance)
        return instance
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

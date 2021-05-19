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
    
    @inlinable public func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
       var copySelf = self
       try block(&copySelf)
       return copySelf
     }
}

extension Sugar where Self: NSObject {
    
    @inlinable public func `do`(_ block: (Self) throws -> Void) rethrows {
      try block(self)
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

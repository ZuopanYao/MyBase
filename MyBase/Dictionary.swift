//
//  Dictionary.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import Foundation

// MARK: - Extension Dictionary
extension Dictionary {
    
    /// 与另外一个字典合并
    public func union(_ elements: [Key: Value]) -> [Key: Value] {
        var base = self
        for (key, value) in elements {
            base[key] = value
        }
        return base
    }
    
    /// 所有的 Key
    public var allKeys: [Key] {
        keys.map { $0 }
    }
    
    /// 所有的 Value
    public var allValues: [Value] {
        values.map { $0 }
    }
}

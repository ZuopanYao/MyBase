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
}

//
//  Dictionary.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import Foundation

// MARK: - Extension Dictionary
public extension Dictionary {
    
    /// 与另外一个字典合并
    @available(iOS, deprecated: 10.0, message: "Use `+` instead")
    func union(_ elements: [Key: Value]) -> [Key: Value] {
        var base = self
        for (key, value) in elements {
            base[key] = value
        }
        return base
    }
    
    @inlinable static func + (lhs: Self, rhs: Self) -> Self {
        var dictionary = lhs
        rhs.forEach { (key, value) in
            dictionary[key] = value
        }
        return dictionary
    }
}

public extension Dictionary.Keys {
    
    var items: [Element] { map { $0 } }
}

public extension Dictionary.Values {
    
    var items: [Element] { map { $0 } }
}

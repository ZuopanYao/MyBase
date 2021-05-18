//
//  Array.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import Foundation

// MARK: - Extension Array
extension Array where Element: SignedInteger {
    
    /// 数组求和
    public func sum() -> Element {
        return reduce(0, { $0 + $1 })
    }
    
    /// 数组平均值
    public func avg() -> Element {
        return sum() / Element(count)
    }
}

extension Array where Element == Float {
    
    /// 数组求和
    public func sum() -> Element {
        return reduce(0.0, { $0 + $1 })
    }
    
    /// 数组平均值
    public func avg() -> Element {
        return sum() / Element(count)
    }
}

extension Array where Element == Double {
    
    /// 数组求和
    public func sum() -> Element {
        return reduce(0.0, { $0 + $1 })
    }
    
    /// 数组平均值
    public func avg() -> Element {
        return sum() / Element(count)
    }
}

extension Array {

    /// 数组切片
    public subscript(bounds: Range<Int>) -> [Element] {
        return prefix(bounds.upperBound).suffix(bounds.lowerBound + 1)
    }
}

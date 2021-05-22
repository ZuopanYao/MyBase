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
        let slice: ArraySlice<Element> = self[bounds]
        return slice.map { $0 }
    }
    
    /// 从指定位置将数组分割成2个数组
    /// - Parameter at: 分割位置在第几个元素后
    /// - Returns: 元组
    public func split(at: Int) -> ([Element], [Element]) {
        // swiftlint:disable:previous identifier_name
        return (prefix(at).map { $0 }, suffix(count - at))
    }
    
    /// 从数组中间开始，往两端取元素
    /// - Parameters:
    ///   - count: 取多少个元素
    ///   - isFloor: 计算下标时非偶数时取整方式，默认 true (向下取整)
    /// - Returns: 数组
    public func middle(count: Int, isFloor: Bool = true) -> [Element] {
        let middleIndex = Float(self.count - count) / 2.0
        let index = Int(isFloor ? floor(middleIndex) : ceil(middleIndex))
        return self[index ..< index + count]
    }
}

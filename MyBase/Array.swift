//
//  Array.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import Foundation

// MARK: - Extension Array

extension Array where Element: Numeric {
    
    /// 数组求和
    public func sum() -> Element {
        return reduce(0, { $0 + $1 })
    }
}

extension Array where Element: SignedInteger {
    
    /// 数组平均值
    public func avg() -> Element {
        return sum() / Element(count)
    }
}

extension Array where Element: FloatingPoint {
    
    /// 数组平均值
    public func avg() -> Element {
        return sum() / Element(count)
    }
}

extension Array where Element == Int {
    
    /// Stride
    public var stride: [Element] {
        Swift.stride(from: self[0], to: self[1], by: self[2]).map { $0 }
    }
    
    /// Stride with through
    public var through: [Element] {
        Swift.stride(from: self[0], through: self[1], by: self[2]).map { $0 }
    }
}

extension Array {

    /// 数组切片
    public subscript(bounds: Range<Int>) -> [Element] {
        let slice: ArraySlice<Element> = self[bounds]
        return slice.map { $0 }
    }
    
    /// 从指定位置将数组分割成2个数组
    ///
    /// - Parameters:
    ///     - at: 分割位置在第几个元素后
    ///
    /// - Returns: 元组
    ///
    /// # Example
    ///
    ///     let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    ///     let (before, after) = array.split(at: 5)
    ///     print(before)   /// [1, 2, 3, 4, 5]
    ///     print(after)    /// [6, 7, 8, 9, 10]
    public func split(at: Int) -> ([Element], [Element]) {
        // swiftlint:disable:previous identifier_name
        return (prefix(at).map { $0 }, suffix(count - at))
    }
    
    /// 从数组中间开始，往两端取元素
    ///
    /// - Parameters:
    ///   - count: 取多少个元素
    ///   - isFloor: 计算下标时非偶数时取整方式，默认 true (向下取整)
    ///
    /// - Returns: 数组
    ///
    /// # Example
    ///
    ///     let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    ///     print(array.middle(count: 4))                /// [4, 5, 6, 7]
    ///     print(array.middle(count: 3, isFloor: true)) /// [4, 5, 6]
    ///     print(array.middle(count: 3, isFloor: false))/// [5, 6, 7]
    public func middle(count: Int, isFloor: Bool = true) -> [Element] {
        let middleIndex = Float(self.count - count) / 2.0
        let index = Int(isFloor ? floor(middleIndex) : ceil(middleIndex))
        return self[index ..< index + count]
    }
    
    /// 数组切片
    /// - Parameters:
    ///     - rangeIndexs: [Range<Int>]，区间分割下标
    ///
    /// - Returns: [[Element]]
    ///
    /// # Example
    ///
    ///     let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    ///     let results = array.split(with: [0..<3, 3..<5, 5..<7, 7..<array.count])
    ///     print(results[0]) /// [1, 2, 3]
    ///     print(results[1]) /// [4, 5]
    ///     print(results[2]) /// [6, 7]
    ///     print(results[3]) /// [8, 9, 10]
    public func split(with rangeIndexs: [Range<Int>]) -> [[Element]] {
        var resluts: [[Element]] = []
        rangeIndexs.forEach {
            resluts.append(self[$0])
        }
        return resluts
    }
}

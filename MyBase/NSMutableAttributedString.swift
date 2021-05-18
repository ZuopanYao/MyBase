//
//  NSMutableAttributedString.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import Foundation

// MARK: - Extension NSMutableAttributedString
extension NSMutableAttributedString {
    
    /// 获取 NSRange
    /// - Parameters:
    ///   - start: Int, 默认 nil,可选
    ///   - end:  Int, 默认 nil,可选
    /// - Returns: NSRange
    public func range(_ start: Int = 0, _ end: Int? = nil) -> NSRange {
        return string.range(start, end)
    }
}

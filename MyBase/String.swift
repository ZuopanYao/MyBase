//
//  String.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import UIKit

// MARK: - Extension String
extension String {
    
    public func replace(_ replaceItems: [(old: String, new: String)]) -> String {
        
        var pointee = self
        replaceItems.forEach { (element) in
            pointee = pointee.replacingOccurrences(of: element.old, with: element.new)
        }
        return pointee
    }
    
    public func replace(_ old: String, _ new: String) -> String {
        return replacingOccurrences(of: old, with: new)
    }
    
    /// 生成随机字符串
    ///
    /// - Parameters:
    ///   - count: 生成字符串长度
    ///   - isLetter: false=大小写字母和数字组成，true=大小写字母组成，默认为false
    /// - Returns: String
    public static func random(_ count: Int, _ isLetter: Bool = false) -> String {
        
        // swiftlint:disable:next identifier_name
        var ch: [CChar] = Array(repeating: 0, count: count)
        for index in 0..<count {
            
            var num = isLetter ? arc4random_uniform(58)+65:arc4random_uniform(75)+48
            if num > 57 && num < 65 && isLetter == false {
                num = num % 57 + 48
            } else if num > 90 && num < 97 { num = num % 90 + 65 }
            
            ch[index] = CChar(num)
        }
        
        return "\(String(cString: ch).prefix(count))"
    }
    
    /// start 表示开始下标， end 表示结束下标
    public subscript(start: Int, end: Int) -> String {
        let start = index(startIndex, offsetBy: start)
        let end = index(start, offsetBy: end)
        return "\(self[start..<end])"
    }
    
    /// 元组第一个元素为开始位置; 第二个元素，1表示正坐标，其他表示负坐标
    public subscript(factor: (Int, Int)) -> String {
        if factor.1 == 1 {
            let start = index(startIndex, offsetBy: factor.0)
            return "\(self[start..<endIndex])"
        }
        
        let end = index(startIndex, offsetBy: factor.0)
        return "\(self[startIndex..<end])"
    }
    
    /// 计算字符串显示Size
    public func box(_ limitWidth: CGFloat, font: UIFont) -> CGSize {
        let size = (self as NSString).boundingRect(with: CGSize(width: limitWidth,
                                                                height: CGFloat.greatestFiniteMagnitude),
                                                   options: .usesLineFragmentOrigin,
                                                   attributes: [NSAttributedString.Key.font: font], context: nil).size
        return CGSize(width: ceil(Double(size.width)), height: ceil(Double(size.height)))
    }
    
    /// 获取 NSRange
    /// - Parameters:
    ///   - start: Int, 默认 nil,可选
    ///   - end:  Int, 默认 nil,可选
    /// - Returns: NSRange
    public func range(_ start: Int? = nil, _ end: Int? = nil) -> NSRange {
        
        guard let start = start, let  end = end else {
            return NSRange(location: 0, length: count)
        }
        return NSRange(location: start, length: end - start)
    }
    
    public var int: Int { Int(double) }
    public var float: Float { Float(double) }
    public var double: Double { Double(self) ?? 0.0 }
    
    /// 对子字符串进行 attributes
    public func attributed(_ markValue: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: self)
        let rangeIndex = range(of: markValue)!
        let attributesRange = NSRange(rangeIndex.lowerBound..<rangeIndex.upperBound, in: self)
        attributedString.addAttributes(attributes, range: attributesRange)
        return attributedString
    }
}

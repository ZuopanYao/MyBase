//
//  String.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import UIKit
import CommonCrypto

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
    ///   - start: 开始下标, 默认 0,可选
    ///   - end:  结束下标, 默认 nil(到字符串最后),可选
    /// - Returns: NSRange
    public func range(_ start: Int = 0, _ end: Int? = nil) -> NSRange {
        var endIndex: Int = count - 1
        if let end = end {
            endIndex = end
        }
        return NSRange(location: start, length: endIndex - start + 1)
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
    
    /// 转为 File URL
    public var fileURL: URL? { URL(fileURLWithPath: self) }
    
    /// 转为 URL
    public var url: URL? { URL(string: self) }
    
    /// 通过图片名称实例 UIImage
    public var image: UIImage? { UIImage(named: self) }
    
    /// MD5
    /// - Parameters:
    ///   - salt: 加盐, 默认为 ""
    ///   - isUpper: 返回大写，默认为 false
    /// - Returns: String
    public func md5(_ salt: String = "", isUpper: Bool = false) -> String {
        let newValue = "\(salt)\(self)"
        let chars = newValue.cString(using: .utf8)!
        let bytesLength = CC_LONG(newValue.lengthOfBytes(using: .utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        CC_MD5(chars, bytesLength, result)
        
        var hash: String = ""
        for index in 0..<digestLength {
            hash.append(String(format: "%02x", result[index]))
        }
        
        result.deallocate()
        return isUpper ? hash.uppercased() : hash
    }
    
    /// to Data with UTF-8 encoding
    public var data: Data? { data(using: .utf8) }
}

extension String {
    
    /// 本地时间时间转换成时间戳
    public func timeIntervalSince1970(_ format: Date.Format = .middle) -> TimeInterval {
        Date.formatter.dateFormat = format.rawValue
        return Date.formatter.date(from: self)?.timeIntervalSince1970 ?? 0.0
    }
    
    /// 本地时间时间转换成 Date
    public func date(_ format: Date.Format = .middle) -> Date? {
        Date.formatter.dateFormat = format.rawValue
        return Date.formatter.date(from: self)
    }
}

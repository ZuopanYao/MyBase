//
//  String.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import UIKit
import CommonCrypto

// MARK: - Extension String
public extension String {
    
    @available(iOS, deprecated: 10.0, message: "Use `replace(_: [String: String])` instead")
    func replace(_ replaceItems: [(old: String, new: String)]) -> String {
        var pointee = self
        replaceItems.forEach { (element) in
            pointee = pointee.replacingOccurrences(of: element.old, with: element.new)
        }
        return pointee
    }
    
    /// 替换
    /// - Parameter replaceItems: [oldValue: newValue]
    /// - Returns: String
    func replace(_ replaceItems: [String: String]) -> String {
        var pointee = self
        replaceItems.forEach { (oldValue, newValue) in
            pointee = pointee.replacingOccurrences(of: oldValue, with: newValue)
        }
        return pointee
    }
    
    /// 替换
    func replace(_ old: String, _ new: String) -> String {
        return replacingOccurrences(of: old, with: new)
    }
    
    /// 生成随机字符串
    ///
    /// - Parameters:
    ///   - count: 生成字符串长度
    ///   - isLetter: false=大小写字母和数字组成，true=大小写字母组成，默认为false
    /// - Returns: String
    static func random(_ count: Int, _ isLetter: Bool = false) -> String {
        
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
    subscript(start: Int, end: Int) -> String {
        let start = index(startIndex, offsetBy: start)
        let end = index(start, offsetBy: end)
        return "\(self[start..<end])"
    }
    
    /// 元组第一个元素为开始位置; 第二个元素，1表示正坐标，其他表示负坐标
    subscript(factor: (Int, Int)) -> String {
        if factor.1 == 1 {
            let start = index(startIndex, offsetBy: factor.0)
            return "\(self[start..<endIndex])"
        }
        
        let end = index(startIndex, offsetBy: factor.0)
        return "\(self[startIndex..<end])"
    }
    
    /// 计算字符串显示Size
    func box(_ limitWidth: CGFloat, font: UIFont) -> CGSize {
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
    func range(_ start: Int = 0, _ end: Int? = nil) -> NSRange {
        var endIndex: Int = count - 1
        if let end = end {
            endIndex = end
        }
        return NSRange(location: start, length: endIndex - start + 1)
    }
    
    var int: Int { Int(double) }
    var float: Float { Float(double) }
    var double: Double { Double(self) ?? 0.0 }
    
    /// 对子字符串进行 attributes
    func attributed(_ markValue: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: self)
        let rangeIndex = range(of: markValue)!
        let attributesRange = NSRange(rangeIndex.lowerBound..<rangeIndex.upperBound, in: self)
        attributedString.addAttributes(attributes, range: attributesRange)
        return attributedString
    }
    
    /// 转为 File URL
    var fileURL: URL? { URL(fileURLWithPath: self) }
    
    // file Exists
    var fileIsExists: Bool {
        FileManager.default.fileExists(atPath: self)
    }
    
    /// folder Exists
    var folderIsExists: Bool {
        var isDirectory: ObjCBool = true
        return FileManager.default.fileExists(atPath: self, isDirectory: &isDirectory)
    }
    
    /// 转为 URL
    var url: URL? { URL(string: self) }
    
    /// 通过图片名称实例 UIImage
    var image: UIImage? { UIImage(named: self) }
    
    /// MD5
    /// - Parameter format: "X" 返回大写，"x" 返回小写，默认 "X"
    /// - Returns: String
    func md5(_ format: String = "X") -> String {
        guard let cString = cString(using: .utf8) else { return "" }
        var digests: [UInt8] = .init(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(cString, CC_LONG(cString.count - 1), &digests)
        return digests.map { Self.init(format: "%02\(format)", $0) }.joined()
    }
    
    /// MD5
    /// - Parameters:
    ///   - salt: 加盐
    ///   - format: "X" 返回大写，"x" 返回小写，默认 "X"
    /// - Returns: String
    func md5WithSalt(_ salt: String, format: String = "X") -> String {
        return (salt + self).md5(format)
    }
    
    /// to Data with UTF-8 encoding
    var data: Data? { data(using: .utf8) }
}

public extension String {
    
    /// 本地时间时间转换成时间戳
    func timeIntervalSince1970(_ format: Date.Format = .middle) -> TimeInterval {
        Date.formatter.dateFormat = format.rawValue
        return Date.formatter.date(from: self)?.timeIntervalSince1970 ?? 0.0
    }
    
    /// 本地时间时间转换成 Date
    func date(_ format: Date.Format = .middle) -> Date? {
        Date.formatter.dateFormat = format.rawValue
        return Date.formatter.date(from: self)
    }
}

//
//  Number.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import UIKit

// MARK: - Extension Int
extension Int {
    
    /// 转成时间格式，六十进制格式显示
    public var time: String {
        let remainderSecond = quotientAndRemainder(dividingBy: 60)
        let remainderMinute = remainderSecond.quotient.quotientAndRemainder(dividingBy: 60)
        let remainderHour = remainderMinute.quotient.quotientAndRemainder(dividingBy: 60)
        
        guard remainderSecond.quotient > 0 else {
            return String(format: "%02d", remainderSecond.remainder)
        }
        
        guard remainderMinute.quotient > 0 else {
            return String(format: "%02d:%02d", remainderMinute.remainder, remainderSecond.remainder)
        }
        
        return String(format: "%02d:%02d:%02d", remainderHour.remainder, remainderMinute.remainder, remainderSecond.remainder)
    }
}

extension SignedInteger {
    
    public var int: Int { Int(self) }
    public var float: Float { Float(self) }
    public var double: Double { Double(self) }
    public var cgFloat: CGFloat { CGFloat(self) }
}

extension FloatingPoint {
    
    public var int: Int { Int(double) }
    public var float: Float { Float(double) }
    /// 向上取整
    public var upInt: Int { Int(ceil(double)) }
    public var cgFloat: CGFloat { CGFloat(double) }
    public var double: Double { Double("\(self)") ?? 0.0 }
}

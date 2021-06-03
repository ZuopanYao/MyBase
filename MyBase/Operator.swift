//
//  Operator.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import Foundation

infix operator ~~: ComparisonPrecedence
infix operator <>: LogicalDisjunctionPrecedence
infix operator <!>: LogicalDisjunctionPrecedence

/// 正则表达式匹配
public func ~~ (origin: String, regular: String) -> Bool {
    
    let predicate = NSPredicate(format: "SELF MATCHES %@", regular)
    return predicate.evaluate(with: origin)
}

/// 当 condition 为 true 时， 执行 closure
public func <> (condition: Bool, closure: () -> Void) {
    condition ? closure() : nil
}

/// 当 condition 为 false 时， 执行 closure
public func <!> (condition: Bool, closure: () -> Void) {
    condition ? nil : closure()
}

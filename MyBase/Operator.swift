//
//  Operator.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import Foundation

infix operator ~~: ComparisonPrecedence
infix operator <--: LogicalDisjunctionPrecedence
infix operator -->: LogicalDisjunctionPrecedence

/// 正则表达式匹配
public func ~~ (origin: String, regular: String) -> Bool {
    
    let predicate = NSPredicate(format: "SELF MATCHES %@", regular)
    return predicate.evaluate(with: origin)
}

public func --> (condition: Bool, closure: @autoclosure () -> Void) {
    if condition {
        closure()
    }
}

public func <-- (condition: Bool, closure: @autoclosure () -> Void) {
    if condition == false {
        closure()
    }
}

public func <-- (closure: @autoclosure () -> Void, condition: Bool) -> Bool {
    if condition == false {
        closure()
    }
    return condition
}

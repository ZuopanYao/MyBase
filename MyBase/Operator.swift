//
//  Operator.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import Foundation

precedencegroup RegularPrecedence {
    
    lowerThan: AdditionPrecedence       // 优先级, 比加法运算低
    associativity: none                 // 结合方向:left, right or none
    assignment: false                   // true=赋值运算符,false=非赋值运算符
}

infix operator ~~: RegularPrecedence

/// 正则表达式匹配
public func ~~ (origin: String, regular: String) -> Bool {
    
    let predicate = NSPredicate(format: "SELF MATCHES %@", regular)
    return predicate.evaluate(with: origin)
}

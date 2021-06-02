//
//  Any.swift
//  MyBase
//
//  Created by Harvey on 2021/6/2.
//

import Foundation

/// 判断可选类型是否为 nil
public func isNil(_ any: Any?) -> Bool {
    switch any {
    case .none: return true
    case .some: return false
    }
}

/// 判断可选类型是否有值
public func isValue(_ any: Any?) -> Bool {
    switch any {
    case .none: return false
    case .some: return true
    }
}

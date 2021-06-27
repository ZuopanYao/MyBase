//
//  Async.swift
//  
//
//  Created by Harvey on 2020/3/14.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import Foundation

/// 异步执行
/// - Parameters:
///   - workQueue: 在哪个线程上执行，默认为主线程
///   - delay: 延迟执行，单位秒，默认 0.0
///   - block: 做些事情
@available(iOS, deprecated: 10.0, message: "Use queue(_:delay:asyncExecute:) instead")
public func async(on workQueue: DispatchQueue = .main, delay: TimeInterval = 0.0, block: @escaping (() -> Void)) {
    guard delay > 0.0 else { return workQueue.async(execute: block) }
    workQueue.asyncAfter(wallDeadline: .now() + delay, execute: block)
}

/// 异步执行
/// - Parameters:
///   - workQueue: 在哪个线程上执行
///   - delay: 延迟执行，单位秒，默认 0.0
///   - asyncExecute: 做些事情
public func queue(_ workQueue: DispatchQueue, delay: TimeInterval = 0.0, asyncExecute: @escaping (() -> Void)) {
    guard delay > 0.0 else { return workQueue.async(execute: asyncExecute) }
    workQueue.asyncAfter(wallDeadline: .now() + delay, execute: asyncExecute)
}

public extension DispatchQueue {
    static let global: DispatchQueue = .global()
}

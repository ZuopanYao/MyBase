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
@available(iOS, deprecated: 10.0, message: "Use queue(_:delay:execute:) instead")
public func async(on workQueue: DispatchQueue = .main, delay: TimeInterval = 0.0, block: @escaping (() -> Void)) {
    guard delay > 0.0 else { return workQueue.async(execute: block) }
    workQueue.asyncAfter(wallDeadline: .now() + delay, execute: block)
}

/// 异步执行
/// - Parameters:
///   - workQueue: 在哪个线程上执行
///   - delay: 延迟执行，单位秒，默认 0.0
///   - execute: 做些事情
public func queue(_ workQueue: DispatchQueue, delay: TimeInterval = 0.0, execute: @escaping (() -> Void)) {
    guard delay > 0.0 else { return workQueue.async(execute: execute) }
    workQueue.asyncAfter(wallDeadline: .now() + delay, execute: execute)
}

@inlinable public func uiThread(delay: TimeInterval = 0.0, execute: @escaping (() -> Void)) {
    queue(.main, delay: delay, execute: execute)
}

public extension DispatchQueue {
    static let global: DispatchQueue = .global()
}

/// 并发队列
/// - Parameters:
///   - tag: 线程标志
///   - tasks: 任务列表
///   - doneNotify: 完成通知
@inlinable public func concurrent(_ tag: String, tasks: [(() -> Void)],
                                  doneNotify: (on: DispatchQueue, block: (() -> Void))? = nil) {
    let taskQueue = DispatchQueue(label: "Create.Concurrent.Queue.\(tag)", attributes: .concurrent)
    let group = DispatchGroup()
    tasks.forEach { taskQueue.async(group: group, execute: DispatchWorkItem(block: $0)) }
    guard let doneNotify = doneNotify else { return }
    group.notify(queue: doneNotify.on, execute: doneNotify.block)
}

/// 串行队列，异步执行
/// - Parameters:
///   - tag: 线程标志
///   - tasks: 任务列表
///   - doneNotify: 完成通知
@inlinable public func serial(_ tag: String, tasks: [(() -> Void)],
                              doneNotify: (on: DispatchQueue, block: (() -> Void))? = nil) {
    let taskQueue = DispatchQueue(label: "Create.Serial.Queue.\(tag)")
    taskQueue.async {
        let group = DispatchGroup()
        tasks.forEach {
            group.enter()
            $0()
            group.leave()
        }
        guard let doneNotify = doneNotify else { return }
        group.notify(queue: doneNotify.on, execute: doneNotify.block)
    }
}

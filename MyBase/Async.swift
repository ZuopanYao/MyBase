//
//  Async.swift
//  
//
//  Created by Harvey on 2020/3/14.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import Foundation

public struct Async {
    /// 主线程
    public static let main = Async(.main)
    /// 全局队列
    public static let global = Async(.global)
    
    public typealias Work = () -> Void
    
    private let queue: DispatchQueue
    public init(_ queue: DispatchQueue) {
        self.queue = queue
    }
    
    public func delay(_ delay: TimeInterval, `do`: @escaping Work) {
        // swiftlint:disable:previous identifier_name
        queue.asyncAfter(wallDeadline: .now() + delay, execute: `do`)
    }
    
    public func `do`(_ do: @escaping Work) {
        // swiftlint:disable:previous identifier_name
        queue.async(execute: `do`)
    }
}

extension DispatchQueue {
    static let global = DispatchQueue.global()
    
    /// 创建一个新队列
    public static func create(_ label: String) -> DispatchQueue {
        return DispatchQueue(label: label, qos: .default)
    }
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

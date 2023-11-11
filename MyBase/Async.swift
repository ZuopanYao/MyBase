//
//  Async.swift
//  
//
//  Created by Harvey on 2020/3/14.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import Foundation

public var async = Async()
public struct Async {
    
    init() { }
    
    public typealias Work = () -> Void
    
    private var queue: DispatchQueue = .main
    
    /// 当 label 为空时，使用全局队列
    public mutating func global(_ label: String = "") -> Self {
        self.queue = label.count > 0 ? .global : .create(label)
        return self
    }
    
    public func delay(_ delay: TimeInterval, work: @escaping Work) {
        queue.asyncAfter(wallDeadline: .now() + delay, execute: work)
    }
    
    public func work(_ work: @escaping Work) {
        queue.async(execute: work)
    }
}

extension DispatchQueue {
    static let global = DispatchQueue.global()
    
    static func create(_ label: String) -> DispatchQueue {
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

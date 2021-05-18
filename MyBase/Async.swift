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
public func async(on workQueue: DispatchQueue = .main, delay: TimeInterval = 0.0, block: @escaping (() -> Void)) {
    if delay == 0.0 {
        workQueue.async(execute: block)
        return
    }
    workQueue.asyncAfter(deadline: DispatchTime.now() + delay, execute: block)
}

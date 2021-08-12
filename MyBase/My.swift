//
//  My.swift
//  MyBase
//
//  Created by Harvey on 2021/8/12.
//

import Foundation

/// 计算代码片段执行时间
@inlinable public func costTime(block: () -> Void) {
    let start = mach_absolute_time()
    block()
    let stop = mach_absolute_time()
    puts("\(stop - start) ns(纳秒)", "\((stop - start) / 1000) µs(微秒)", "\((stop - start) / 1000000) ms(毫秒)")
}

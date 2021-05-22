//
//  Logger.swift
//
//
//  Created by Harvey on 2021/4/27.
//

import Foundation

public class Logger {

    public static var isDebug: Bool = false
    public static var saveHandler: ((_ value: String) -> Void)?

    fileprivate static let shared = Logger()
    private init() { }

    fileprivate var dateString: String { Date().format(.full) }
}

/// 自定义打印函数
public func puts(_ items: Any..., file: String = #file, method: String = #function, line: Int = #line) {
    objc_sync_enter(Logger.shared)
    let factor = "\(Logger.shared.dateString) in \(file.split(separator: "/").last!) \(method) [Line \(line)]:\n"
    let content = items.compactMap { "\($0)"}.joined(separator: "\n")
    let log = factor + content + "\n"
    if Logger.isDebug { print(log) }
    Logger.saveHandler?(log + "\n")
    objc_sync_exit(Logger.shared)
}

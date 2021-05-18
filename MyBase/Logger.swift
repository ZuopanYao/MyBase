//
//  Logger.swift
//
//
//  Created by Harvey on 2021/4/27.
//

import Foundation

public class Logger {

    static var isDebug: Bool = false
    static let shared = Logger()
    private init() {
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }

    fileprivate let formatter: DateFormatter
    fileprivate var dateString: String {
        return formatter.string(from: Date())
    }
    
    public static var saveHandler: ((_ value: String) -> Void)?
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

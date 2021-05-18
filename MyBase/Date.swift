//
//  Date.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import Foundation

// MARK: - Extension Date
extension Date {
    
    private static let formatter = DateFormatter()

    public struct Format {
        
        fileprivate let rawValue: String
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
        /// e.g. 2020-01-01
        public static let short: Format = .init("yyyy-MM-dd")
        
        /// e.g. 2020年01月01日
        public static let short1: Format = .init("yyy年MM月dd日")
        
        /// e.g. 2020-01-01 01:01
        public static let middle: Format = .init("yyyy-MM-dd HH:mm")
        
        /// e.g. 2020年01月01日 01:01
        public static let middle1: Format = .init("yyy年MM月dd日 HH:mm")
        
        /// e.g. 2020-01-01 01:01:01
        public static let long: Format = .init("yyyy-MM-dd HH:mm:ss")
        
        /// e.g. 2020年01月01日 01:01:01
        public static let long1: Format = .init("yyyy年MM月dd日 HH:mm:ss")
        
        /// e.g. 2020-01-01 01:01:01.088
        public static let full: Format = .init("yyyy-MM-dd HH:mm:ss.SSS")
        
        /// e.g. 2020年01月01日 01:01:01.088
        public static let full1: Format = .init("yyyy年MM月dd日 HH:mm:ss.SSS")
    }

    /// 格式化成本地时间
    public func format(_ format: Date.Format = .middle) -> String {
        Self.formatter.dateFormat = format.rawValue
        return Self.formatter.string(from: self)
    }
}

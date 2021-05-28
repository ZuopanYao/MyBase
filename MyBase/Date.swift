//
//  Date.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import Foundation

// MARK: - Extension Date
extension Date {
    
    static let formatter = DateFormatter()

    public struct Format {
        
        let rawValue: String
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
    
    public enum Unit {
        case minute(Int)
        case hour(Int)
        case day(Int)
        
        /// 转换成秒
        public var second: TimeInterval {
            switch self {
            case .minute(let minute): return 60.0 * Double(minute)
            case .hour(let hour): return 60.0 * 60.0 * Double(hour)
            case .day(let day): return 60.0 * 60.0 * 24.0 * Double(day)
            }
        }
    }
}

public let today: Date = .init()

/// 本地化
extension Date {
    /// 星期几
    public enum Week: Int {
        /// 星期日
        case sun = 1
        /// 星期一
        case mon
        /// 星期二
        case tue
        /// 星期三
        case wed
        /// 星期四
        case thur
        /// 星期五
        case fri
        /// 星期六
        case sat
    }

    /// 当天的第一秒
    public var fromTimeInterval: TimeInterval {
        let today = format(.short)
        return today.timeIntervalSince1970(.short)
    }
    
    /// 当天最后一秒
    public var toTimeInterval: TimeInterval { fromTimeInterval + Unit.day(1).second }
    
    /// 哪一年
    public var year: Int { component(.year) }

    /// 哪个月
    public var month: Int { component(.month) }

    /// 当月的第几天
    public var day: Int { component(.day) }

    /// 当月的第几周
    public var  weekOfMonth: Int { component(.weekOfMonth) }

    /// 今年的第几周
    public var  weekOfYear: Int { component(.weekOfYear) }

    /// 星期几
    public var weekDay: Week { Week(rawValue: component(.weekday))! }
    
    /// 假设当天是周五，表示本月的第几个周五
    public var weekdayOrdinal: Int { component(.weekdayOrdinal) }
    
    private func component(_ component: Calendar.Component) -> Int {
        return Calendar.autoupdatingCurrent.component(component, from: self)
    }
}

//
//  Notify.swift
//  
//
//  Created by Harvey on 2020/1/5.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import Foundation

public class Notify {
    
    private static let notification = NotificationCenter.default

    public struct Name {
        
        fileprivate let rawValue: String
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    public static func remove(_ observer: Any) {
        notification.removeObserver(observer)
    }
    
    public static func remove(_ observer: Any, name: Notify.Name, object: Any? = nil) {
        remove(observer, name: Notification.Name(name.rawValue), object: object)
    }
    
    public static func remove(_ observer: Any, name: Notification.Name, object: Any? = nil) {
        notification.removeObserver(observer, name: name, object: object)
    }
    
    public static func post(name: Notify.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        post(name: Notification.Name(name.rawValue), object: object, userInfo: userInfo)
    }
    
    public static func post(name: NSNotification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        notification.post(name: name, object: object, userInfo: userInfo)
    }
    
    public static func add(name: Notify.Name, object: Any? = nil,
                           queue: OperationQueue? = nil, usingblock: @escaping (Notification) -> Void) {
        add(name: Notification.Name(name.rawValue), object: object, queue: queue, usingblock: usingblock)
    }
    
    public static func add(name: NSNotification.Name, object: Any? = nil,
                           queue: OperationQueue? = nil, usingblock: @escaping (Notification) -> Void) {
        _ = notification.addObserver(forName: name, object: object, queue: queue, using: usingblock)
    }
    
    public static func add(_ observer: Any, selector: Selector, name: Notify.Name, object: Any? = nil) {
        add(observer, selector: selector, name: Notification.Name(name.rawValue), object: object)
    }
    
    public static func add(_ observer: Any, selector: Selector, name: NSNotification.Name, object: Any? = nil) {
        notification.addObserver(observer, selector: selector, name: name, object: object)
    }
}

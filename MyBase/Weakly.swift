//
//  Weakly.swift
//  MyBase
//
//  Created by Harvey on 2021/6/18.
//

import Foundation

public class Weakly: NSObject {

    weak var object: NSObject?
    
    public init(_ object: NSObject) {
        self.object = object
    }
}

public extension Array where Element == Weakly {
    
    func contains(_ object: NSObject) -> Bool {
        return (filter { $0.object == object }).count > 0
    }
    
    func strongReference() -> [Element] {
        return filter { isValue($0.object) }
    }
}

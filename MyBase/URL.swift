//
//  URL.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import Foundation

// MARK: - Extension URL
 
public extension URL {
    /// Only web url
    var parameters: [String: String] {
        var keyValues: [String: String] = [:]
        guard let query = query else {
            return keyValues
        }
        query
            .split(separator: "&")
            .map { "\($0)" }
            .forEach {
                let array = $0.split(separator: "=").map { "\($0)" }
                guard array.count == 2 else { return }
                keyValues[array.first!] = array.last!
            }
        
        return keyValues
    }
}

//
//  Data.swift
//  MyBase
//
//  Created by Harvey on 2021/5/18.
//

import Foundation

// MARK: - Extension Data
extension Data {
    
    public func bytes() -> [UInt8] {
        var keyByte = [UInt8](repeating: 0, count: count)
        copyBytes(to: &keyByte, count: count)
        return keyByte
    }
    
    /// to String with UTF-8 encoding
    public var string: String? { String(data: self, encoding: .utf8) }
}

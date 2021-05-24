//
//  Codable.swift
//  MyBase
//
//  Created by Harvey on 2021/5/22.
//

import Foundation

// MARK: - Extension Codable

extension Encodable {
    
    /// JSON encode
    public var encode: Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch { puts(error) }
        return nil
    }
}

extension Decodable {
    
    /// JSON decode
    static public func decode(_ from: Data) -> Self? {
        do {
            return try JSONDecoder().decode(Self.self, from: from)
        } catch { puts(error) }
        return nil
    }
}

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
    
    /// decode to Codable's instance
    static public func decode(_ from: String?) -> [Self]? {
        return from?.components(separatedBy: "&&==&&").compactMap({ $0.data }).compactMap { Self.decode($0) }
    }
}

public extension Array where Element: Codable {
    
    /// Encode to string
    var encode: String? {
        let strings = compactMap { $0.encode?.string }
        return strings.joined(separator: "&&==&&")
    }
}

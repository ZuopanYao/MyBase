//
//  File.swift
//  MyBase
//
//  Created by Harvey on 2021/5/17.
//

import UIKit

public class File {
    
    private let path: String?
    
    /// For Main Bundle, only reading
    public init(_ name: String, ext: String) {
        path = App.Bundle.path(name, ext)
    }
    
    /// reading and writing
    public init(_ filePath: String?) {
        path = filePath
        if FileManager.default.fileExists(atPath: path!) == false {
            FileManager.default.createFile(atPath: path!, contents: nil, attributes: nil)
        }
    }
    
    public var data: Data? {
        guard let path = path else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    /// utf8
    public var string: String? {
        guard let data = data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // swiftlint:disable:next line_length
    public func attributedString(options: [NSAttributedString.DocumentReadingOptionKey: Any] = [:], attributes: AutoreleasingUnsafeMutablePointer<NSDictionary?>? = nil) -> NSMutableAttributedString? {
        guard let data = data else { return nil }
        return try? NSMutableAttributedString(data: data, options: options, documentAttributes: attributes)
    }
    
    public var dictionary: [String: Any]? {
        guard let path = path else { return nil }
        return NSDictionary(contentsOfFile: path) as? [String: Any]
    }
        
    private lazy var fileHandle: FileHandle = {
        FileHandle(forUpdatingAtPath: path!)!
    }()
    
    /// 使用新数据，覆盖原始数据
    public func cover(_ data: Data?) {
        guard let data = data else { return }
        fileHandle.seek(toFileOffset: 0)
        fileHandle.write(data)
        fileHandle.truncateFile(atOffset: UInt64(data.count))
    }
    
    /// 使用新数据，覆盖原始数据
    public func cover(_ data: String) {
        cover(data.data(using: .utf8))
    }
    
    /// 末尾追加新数据
    public func append(_ data: Data?) {
        guard let data = data else { return }
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
    }
    
    /// 末尾追加新数据
    public func append(_ data: String) {
        append(data.data(using: .utf8))
    }
    
    /// 将新数据插入到最前面，原始数据后移
    public func prefix(_ data: Data?) {
        guard let data = data else { return }
        var fileData: Data = data
        fileHandle.seek(toFileOffset: 0)
        fileData.append(fileHandle.readDataToEndOfFile())
        fileHandle.seek(toFileOffset: 0)
        fileHandle.write(fileData)
    }
    
    /// 将新数据插入到最前面，原始数据后移
    public func prefix(_ data: String) {
        prefix(data.data(using: .utf8))
    }
}

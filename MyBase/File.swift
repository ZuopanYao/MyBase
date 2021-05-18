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

// swiftlint:disable identifier_name
extension File {
    
    public struct Size {
    
        /// 存储单位转换
        public enum Unit: Double {
            /// byte
            case byte = 1.0
            /// KB
            case kb = 1024.0
            /// MB
            case mb = 1048576.0
            /// GB
            case gb = 1073741824.0
        }
        
        private var bytes: UInt64 = 0
        private var filePath: String?
        
        public init(_ filePath: String) {
            self.filePath = filePath
        }
        
        fileprivate init(_ bytes: UInt64) {
            self.bytes = bytes
        }
        
        private func getBytes() -> UInt64 {
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: filePath!)
                 return attributes[.size] as? UInt64 ?? 0
            } catch {
                puts(error)
                return 0
            }
        }
        
        public func value(_ unit: Unit) -> UInt64 {
            let doubleValue: Double = value(unit)
            return UInt64(doubleValue)
        }
        
        public func value(_ unit: Unit) -> Int {
            let doubleValue: Double = value(unit)
            return Int(doubleValue)
        }
        
        public func value(_ unit: Unit) -> Float {
            let doubleValue: Double = value(unit)
            return Float(doubleValue)
        }
        
        public func value(_ unit: Unit) -> Double {
            return Double( filePath == nil ? bytes : getBytes()) / unit.rawValue
        }
    }
    
    public var size: Size { Size(self.path!) }
}

extension File.Size {
    
    /// 计算某个目录下所有文件总 Size
    public static func folder(_ folderPath: String) -> File.Size {
        
        guard let files = FileManager.default.subpaths(atPath: folderPath) else {
            return File.Size(0)
        }
        
        var bytes: UInt64 = 0
        files.forEach { (file) in
            let filePath = folderPath + "/" + file
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: filePath)
                bytes += attributes[.size] as? UInt64 ?? 0
            } catch { puts(error) }
        }
        
        return File.Size(bytes)
    }
}

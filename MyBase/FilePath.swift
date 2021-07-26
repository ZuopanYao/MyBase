//
//  FilePath.swift
//  MyBase
//
//  Created by Harvey on 2021/7/26.
//

import Foundation

public class FilePath {
    
    var path: String
    private var isDirectory: ObjCBool
    private let fileManager: FileManager = .default

    public init(_ path: String, isDirectory: Bool = false) {
        self.path = path
        self.isDirectory = ObjCBool(isDirectory)
    }
    
    /// Returns a Boolean value that indicates whether a file or directory exists at a specified path.
    public var isExists: Bool {
        guard isDirectory.boolValue else { return fileManager.fileExists(atPath: path) }
        return fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
    }
    
    /// Creates a directory / file with given attributes at the specified path.
    public func create() {
        if isExists {
            return
        }
        guard isDirectory.boolValue else {
            fileManager.createFile(atPath: path, contents: nil, attributes: nil)
            return
        }
        
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            puts(error)
        }
    }
}

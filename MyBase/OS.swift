//
//  OS.swift
//  StudyDemo
//
//  Created by Harvey on 2021/4/28.
//

import UIKit

// swiftlint:disable:next type_name
struct OS {
    
    static let version: String = UIDevice.current.systemVersion
    static let model: String = UIDevice.current.model
    static let lang: String = NSLocale.preferredLanguages[0]
    static let country: String = NSLocale.current.currencyCode ?? ""
    
    /// true = 手机越狱了
    static var isJailbroken: Bool {
        #if targetEnvironment(simulator)
        return false
        #endif
        
        let paths: [String] = [
            "/Applications/Cydia.app",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/stash"
        ]
        
        if (paths.filter { FileManager.default.fileExists(atPath: $0) }).count > 0 {
            return true
        }
        
        if let bash = fopen("/bin/bash", "r") {
            fclose(bash)
            return true
        }
        
        do {
            try "TestWrite".write(toFile: "/private/\(NSUUID().uuidString)", atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
}

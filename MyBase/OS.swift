//
//  OS.swift
//  StudyDemo
//
//  Created by Harvey on 2021/4/28.
//

import UIKit

// swiftlint:disable:next type_name
public struct OS {
    
    /// 系统版本号
    public static let version: String = UIDevice.current.systemVersion
    /// 设备类型
    public static let model: String = UIDevice.current.model
    /// 系统语言
    public static let lang: String = NSLocale.preferredLanguages[0]
    /// 国家代号(货币代码)
    public static let country: String = NSLocale.current.currencyCode ?? ""
    
    /// true = 手机越狱了
    public static var isJailbroken: Bool {
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

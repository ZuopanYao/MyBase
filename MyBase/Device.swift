//
//  Device.swift
//  
//
//  Created by Harvey on 2021/4/28.
//

import UIKit

public struct Device {
    
    /// 设备类型 e.g. @"iPhone", @"iPod touch"
    public static let type: String = UIDevice.current.model
    
    /// 设备型号 e.g. @"iPhone 12 Pro Max", "iPad mini"
    public static let model: String = {
        guard UIDevice.current.userInterfaceIdiom == .pad else {
            return Phone(Hardware.platform).model
        }
        return Pad(Hardware.platform).model
    }()
    
    /// 设备名称
    public static let name: String = UIDevice.current.name
    
    public struct OS {
        // swiftlint:disable:previous type_name
        
        /// 系统版本号
        public static let version: String = UIDevice.current.systemVersion
        
        /// 系统名称
        public static let model: String = UIDevice.current.systemName
        
        /// 系统第一语言
        public static let lang: String = NSLocale.preferredLanguages[0]
        
        /// 国家代号(货币代码)
        public static let country: String = NSLocale.current.currencyCode ?? ""
        
        /// true = 手机越狱了
        public static var isJailbroken: Bool {
            if App.isRunOnSimulator {
                return false
            }
            
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
}

protocol DeviceModel {
    
    var platform: String { get set }
    var idiom: String { get set }
    var rawValue: (Int, Int) { get }
}

extension DeviceModel {
    
    var rawValue: (Int, Int) {
        let rawValue = platform.replace(idiom, "").split(separator: ",").compactMap { Int(Double($0) ?? 0.0) }
        return (rawValue.first ?? 0, rawValue.last ?? 0)
    }
}

extension Device {
    
    struct Phone: DeviceModel {
        
        var idiom: String = "iPhone"
        var platform: String
        
        init(_ platform: String) {
            self.platform = platform
        }
        
        var model: String {
            let (first, second) = rawValue
            guard first > 0, second > 0 else { return "Simulator" }
            
            if first == 1, second == 1 { return "iPhone" }
            if first == 1, second == 2 { return "iPhone 3G" }
            if first == 2, second == 1 { return "iPhone 3GS" }
            if first == 3, second < 4 { return "iPhone 4" }
            if first == 4, second == 1 { return "iPhone 4S" }
            if first == 5, second < 3 { return "iPhone 5" }
            if first == 5, second < 5 { return "iPhone 5c" }
            if first == 6, second < 3 { return "iPhone 5s" }
            if first == 7, second == 1 { return "iPhone 6 Plus" }
            if first == 7, second == 2 { return "iPhone 6" }
            if first == 8, second == 1 { return "iPhone 6s" }
            if first == 8, second == 2 { return "iPhone 6s Plus" }
            if first == 8, second == 4 { return "iPhone SE" }
            if first == 9, (second == 1 || second == 3) { return "iPhone 7" }
            if first == 9, (second == 2 || second == 4) { return "iPhone 7 Plus" }
            if first == 10, (second == 1 || second == 4) { return "iPhone 8" }
            if first == 10, (second == 2 || second == 5) { return "iPhone 8 Plus" }
            if first == 10, (second == 3 || second == 6) { return "iPhone X" }
            if first == 11, second == 8 { return "iPhone XR" }
            if first == 11, second == 2 { return "iPhone XS" }
            if first == 11, (second == 4 || second == 6) { return "iPhone XS Max" }
            if first == 12, second == 1 { return "iPhone 11" }
            if first == 12, second == 3 { return "iPhone 11 Pro" }
            if first == 12, second == 5 { return "iPhone 11 Pro Max" }
            if first == 12, second == 8 { return "iPhone SE(2nd generation)" }
            if first == 13, second == 1 { return "iPhone 12 Mini" }
            if first == 13, second == 2 { return "iPhone 12" }
            if first == 13, second == 3 { return "iPhone 12 Pro" }
            if first == 13, second == 4 { return "iPhone 12 Pro Max" }
            
            return platform
        }
    }
    
    struct Pad: DeviceModel {
        
        var idiom: String = "iPad"
        var platform: String
        
        init(_ platform: String) {
            self.platform = platform
        }
        
        var model: String {
            let (first, second) = rawValue
            guard first > 0, second > 0 else { return "Simulator" }
            
            if first == 1, second == 1 { return "iPad" }
            if first == 2, second < 5 { return "iPad 2" }
            if first == 2, second < 8 { return "iPad Mini" }
            if first == 3, second < 4 { return "iPad(3rd generation)" }
            if first == 3, second < 7 { return "iPad(4th generation)" }
            if first == 4, second < 4 { return "iPad Air" }
            if first == 4, second < 7 { return "iPad Mini 2" }
            if first == 4, second < 10 { return "iPad Mini 3" }
            if first == 5, second < 3 { return "iPad Mini 4" }
            if first == 5, second < 5 { return "iPad Air 2" }
            if first == 6, (second == 3 || second == 4) { return "iPad Pro 9.7-inch" }
            if first == 6, (second == 7 || second == 8) { return "iPad Pro 12.9-inch" }
            if first == 6, (second == 11 || second == 12) { return "iPad(5th generation)" }
            if first == 7, second < 3 { return "iPad Pro 12.9-inch(2nd generation)" }
            if first == 7, second < 5 { return "iPad Pro 10.5-inch" }
            if first == 7, second < 7 { return "iPad(6th generation)" }
            if first == 7, (second == 11 || second == 12) { return "iPad(7th generation)" }
            if first == 8, second < 5 { return "iPad Pro 11-inch" }
            if first == 8, second < 9 { return "iPad Pro 12.9-inch(3rd generation)" }
            if first == 8, second < 11 { return "iPad Pro 11-inch(2nd generation)" }
            if first == 8, second < 13 { return "iPad Pro 12.9-inch(4th generation)" }
            if first == 11, second < 3 { return "iPad mini(5th generation)" }
            if first == 11, second < 5 { return "iPad Air(3rd generation)" }
            if first == 11, second < 8 { return "iPad(8th generation)" }
            if first == 13, second < 3 { return "iPad Air(4th generation)" }
            
            return platform
        }
    }
}

//
//  App.swift
//  FreeVPN
//
//  Created by Harvey on 2021/4/27.
//

import UIKit

/// 获取 App 的基础信息
public class App {
    
    /// UIApplication.shared
    public static let shared = UIApplication.shared
    
    private static let info: [String: Any] = Foundation.Bundle.main.infoDictionary ?? [:]
    private init() { }
    
    public struct Version {
        
        /// 版本号
        public static var short: String {
            return info["CFBundleShortVersionString"] as? String ?? ""
        }
        
        /// build 版本号
        public static var build: String {
             return info["CFBundleVersion"] as? String ?? short
        }
    }
    
    /// Bundle Identifier
    public static var bundleID: String {
        return info["CFBundleIdentifier"] as? String ?? ""
    }
    
    /// app 名称
    public static var name: String {
        return self.info["CFBundleName"] as? String ?? ""
    }
    
    /// app 显示名称
    ///
    /// 安装后在桌面显示的名称，一般情况下和 name 是一样，除非手动设置了displayName
    ///
    public static var displayName: String {
        return info["CFBundleDisplayName"] as? String ?? name
    }
    
    public struct Path {
        static let home: String = NSHomeDirectory()
        static let temporary = NSTemporaryDirectory()
        static let document: String = path(.documentDirectory)
        static let library: String = path(.libraryDirectory)
        static let cache: String = path(.cachesDirectory)
        
        private static func path(_ directory: FileManager.SearchPathDirectory) -> String {
            return NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first ?? ""
        }
    }
    
    public struct Bundle {
        static let resource: String = Foundation.Bundle.main.resourcePath ?? ""
        static let executable: String = Foundation.Bundle.main.executablePath ?? ""
        static let builtInPlug: String = Foundation.Bundle.main.builtInPlugInsPath ?? ""
        static let framework: String = Foundation.Bundle.main.privateFrameworksPath ?? ""
        static let sharedSupport: String = Foundation.Bundle.main.sharedSupportPath ?? ""
        static let sharedFramework: String = Foundation.Bundle.main.sharedFrameworksPath ?? ""
        
        fileprivate static let embedded: String? = Foundation.Bundle.main.path(forResource: "embedded", ofType: "mobileprovision")
        
        public static func path(_ name: String, _ ext: String) -> String? {
            return Foundation.Bundle.main.path(forResource: name, ofType: ext)
        }
        
        public static func url(_ name: String, _ ext: String) -> URL? {
            return Foundation.Bundle.main.url(forResource: name, withExtension: ext)
        }
    }
    
    public static var sign: Sign {
        #if targetEnvironment(simulator)
        return .off
        #endif
        
        guard let path = Bundle.embedded else {
            return .appStore
        }
        
        guard let signContent = try? String(contentsOfFile: path, encoding: .ascii) else {
            return .appStore
        }
        
        guard signContent.contains("<key>ProvisionedDevices</key>\n\t<array>") else {
            return .distribution
        }
        return .development
    }
    
    public enum Sign {
        /// for simulator
        case off
        case appStore
        case development
        case distribution
    }
}

//
//  App.swift
//  
//
//  Created by Harvey on 2021/4/27.
//

import UIKit
import CoreMotion

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
        public static let home: String = NSHomeDirectory()
        public static let temporary = NSTemporaryDirectory()
        public static let document: String = path(.documentDirectory)
        public static let library: String = path(.libraryDirectory)
        public static let cache: String = path(.cachesDirectory)
        
        private static func path(_ directory: FileManager.SearchPathDirectory) -> String {
            return NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first ?? ""
        }
    }
    
    public struct Bundle {
        public static let resource: String = Foundation.Bundle.main.resourcePath ?? ""
        public static let executable: String = Foundation.Bundle.main.executablePath ?? ""
        public static let builtInPlug: String = Foundation.Bundle.main.builtInPlugInsPath ?? ""
        public static let framework: String = Foundation.Bundle.main.privateFrameworksPath ?? ""
        public static let sharedSupport: String = Foundation.Bundle.main.sharedSupportPath ?? ""
        public static let sharedFramework: String = Foundation.Bundle.main.sharedFrameworksPath ?? ""
        
        fileprivate static let embedded: String? = Foundation.Bundle.main.path(forResource: "embedded", ofType: "mobileprovision")
        
        public static func path(_ name: String, _ ext: String) -> String? {
            return Foundation.Bundle.main.path(forResource: name, ofType: ext)
        }
        
        public static func url(_ name: String, _ ext: String) -> URL? {
            return Foundation.Bundle.main.url(forResource: name, withExtension: ext)
        }
    }
    
    public static var sign: Sign {
        if App.isRunOnSimulator {
            return .off
        }
        
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

/// For URL
extension App {
    
    public static func canOpen(_ url: URL) -> Bool {
        return shared.canOpenURL(url)
    }
    
    public static func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
                            completionHandler completion: ((Bool) -> Void)? = nil) {
         shared.open(url, options: options, completionHandler: completion)
    }
}

extension App {
    
    /// true = 在模拟器上运行
    public static let isRunOnSimulator: Bool = TARGET_IPHONE_SIMULATOR == 1
    
    /// true = 在 M1 芯片上运行
    public static let isRunOnM1: Bool = {
        CMMotionManager().isAccelerometerAvailable == false && isRunOnSimulator == false
    }()
}

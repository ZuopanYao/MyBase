// swiftlint:disable identifier_name
//
//  Hardware.swift
//  MyBase
//
//  Created by Harvey on 2021/5/16.
//

import Foundation

public struct Hardware {
    
    /// 存储单位转换
    public struct Unit {
        
        public static var radix: Double = 1024.0
        
        private var rawValue: UInt64
        init(_ rawValue: UInt64 = 0) {
            self.rawValue = rawValue
        }
        
        public var byte: UInt64 { rawValue }
        /// KB
        public var kb: Double { Double(rawValue) / Self.radix }
        /// MB
        public var mb: Double { kb / Self.radix }
        /// GB
        public var gb: Double { mb / Self.radix }
    }
}

extension Hardware {
    
    /// physical
    public static let memory: Unit = Unit(ProcessInfo.processInfo.physicalMemory)
    
    public static var usageMemory: UsageMemory {
        
        let info: UnsafeMutablePointer<task_vm_info> = .allocate(capacity: 1)
        var memorySize = mach_msg_type_number_t(MemoryLayout<task_vm_info>.stride)
        let infoMemoryRebound = info.withMemoryRebound(to: integer_t.self, capacity: 1) { $0 }
        let returnCodes = task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), infoMemoryRebound, &memorySize)
        guard returnCodes == KERN_SUCCESS else { return UsageMemory() }
        
        let usage = info.pointee.phys_footprint
        let ratio = Double(usage) /  Double(Self.memory.byte)
        return UsageMemory(current: .init(usage), total: Self.memory, ratio: ratio)
    }
    
    public struct UsageMemory {
        
        public var current: Unit = .init()
        public var total: Unit = .init()
        /// current / total
        public var ratio: Double = 0.0
    }
}

extension Hardware {
    
    public static var diskSize: Unit {
        Unit(fileSystem[.systemSize] as? UInt64 ?? 0)
    }
    
    public static var diskFreeSize: Unit {
        Unit(fileSystem[.systemFreeSize] as? UInt64 ?? 0)
    }
    
    private static var fileSystem: [FileAttributeKey: Any] {
        (try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())) ?? [:]
    }
}

extension Hardware {

    public static var platform: String {
        var size: Int = 0
        if sysctlbyname("hw.machine", nil, &size, nil, 0) < 0 {
            perror("sysctlbyname")
            return ""
        }
        
        var buffer: [UInt8] = .init(repeating: 0, count: size)
        if sysctlbyname("hw.machine", &buffer, &size, nil, 0) < 0 {
            perror("sysctlbyname")
            return ""
        }
        
        return String(cString: buffer)
    }
}

//
//  Network.swift
//  StudyDemo
//
//  Created by Harvey on 2021/6/20.
//

import Foundation

struct Network {
    
    /// 局域网 IP
    static var lanIP: String {
        
        var address: String = ""
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else {
            freeifaddrs(ifaddr)
            return address
        }
        
        var ptr = ifaddr
        // swiftlint:disable:next exclamation
        while ptr != nil {
            defer { ptr = ptr!.pointee.ifa_next }
            
            let interface = ptr!.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            guard addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) else {
                continue
            }
            
            let name = String(cString: interface.ifa_name)
            guard name == "en0" else {
                continue
            }
            
            var addr = interface.ifa_addr.pointee
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                        &hostname, socklen_t(hostname.count),
                        nil, socklen_t(0), NI_NUMERICHOST)
            address = String(cString: hostname)
        }
        
        freeifaddrs(ifaddr)
        return address
    }
    
    static var internetIP: String {
        return ((try? String(contentsOf: URL(string: "https://icanhazip.com")!, encoding: .utf8)) ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

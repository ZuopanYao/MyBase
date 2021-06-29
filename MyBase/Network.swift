//
//  Network.swift
//  MyBase
//
//  Created by Harvey on 2021/6/20.
//

import Foundation
import CoreTelephony
import Alamofire

public class Network {
    
    private static let shared = Network()
    public static var status: Status { shared.status }
    
    /// 启动监听网络变化
    public static func startListening(reachabilityStatusDidChange: (() -> Void)? = nil) {
        shared.reachabilityStatusDidChange = reachabilityStatusDidChange
    }
    
    private let telephonyNetworkInfo: CTTelephonyNetworkInfo
    private var networkReachabilityManager: NetworkReachabilityManager!
    private var reachabilityStatusDidChange: (() -> Void)?

    private var status: Network.Status = .unknown
    private init() {
        telephonyNetworkInfo = CTTelephonyNetworkInfo()
        networkReachabilityManager = NetworkReachabilityManager()
        if isNil(networkReachabilityManager) {
            puts("NetworkReachabilityManager init failed")
            return
        }
        networkReachabilityManager?.startListening(onQueue: .global(qos: .background)) { (networkReachabilityStatus) in
            self.reachabilityStatus(networkReachabilityStatus)
            self.reachabilityStatusDidChange?()
        }
    }
    
    private func reachabilityStatus(_ reachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus) {
        switch reachabilityStatus {
        case .unknown: status = .unknown
        case .notReachable: status = .notReachable
        case .reachable(let connectionType):
            switch connectionType {
            case .cellular: status = .wwan(radioAccessTechnology(registeredWWANTechnology!))
            case .ethernetOrWiFi: status = .wifi
            }
        }
    }
    
    public enum Status {
        case unknown
        case notReachable
        case wwan(Cellular)
        case wifi
    }
    
    public enum Cellular {
        /// After 5G
        case onFuture
        /// 2G
        case on2G
        /// 3G
        case on3G
        /// 4G
        case on4G
        /// 5G
        case on5G
    }
    
    private var registeredWWANTechnology: String? {
        guard #available(iOS 12.0, *) else {
            return telephonyNetworkInfo.currentRadioAccessTechnology
        }
        return telephonyNetworkInfo.serviceCurrentRadioAccessTechnology?.values.filter({ isValue($0) }).first
    }
    
    private func radioAccessTechnology(_ registeredWWANTechnology: String) -> Cellular {
        switch registeredWWANTechnology {
        case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
            return .on2G
        
        case CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyeHRPD:
            return .on3G
            
        case CTRadioAccessTechnologyLTE: return .on4G
            
        default:
            guard #available(iOS 14.1, *), (registeredWWANTechnology == CTRadioAccessTechnologyNRNSA ||
                                                registeredWWANTechnology == CTRadioAccessTechnologyNR)
            else { return .onFuture }
            return.on5G
        }
    }
}

// IP Address
extension Network {
    
    /// 局域网 IP
    public static var lanIP: String {
        
        var address: String = ""
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else {
            freeifaddrs(ifaddr)
            return address
        }
        
        var ptr = ifaddr
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
    
    public static var internetIP: String {
        return ((try? String(contentsOf: URL(string: "https://icanhazip.com")!, encoding: .utf8)) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

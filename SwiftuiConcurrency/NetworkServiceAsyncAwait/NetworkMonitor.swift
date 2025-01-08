//
//  NetworkMonitor.swift
//  SwiftuiConcurrency
//
//  Created by hb on 07/01/25.
//

import Foundation
import Network

final class NetworkMonitor {
    
    // MARK: - Properties
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private var status = NWPath.Status.requiresConnection
    
    public var isCellular: Bool = true
    public var isReachable: Bool {
        status == .satisfied
    }
    
    // MARK: - Singleton
    private init() {}
    
}

extension NetworkMonitor {
    
    // MARK: - Monitor Network Connection
    
    public func startMonitoring() {
        
        monitor.pathUpdateHandler = { [weak self] path in
            
            guard let `self` = self else { return }
            
            status = path.status
            isCellular = path.isExpensive
            
            if path.status == .satisfied {
                if path.usesInterfaceType(.wifi) {
                    debugPrint("CONNECTION:: Wifi")
                } else if path.usesInterfaceType(.cellular) {
                    debugPrint("CONNECTION:: Cellular")
                } else {
                    debugPrint("CONNECTION:: Other")
                }
            } else {
                debugPrint("CONNECTION:: No Connection")
            }
        }
        
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
}

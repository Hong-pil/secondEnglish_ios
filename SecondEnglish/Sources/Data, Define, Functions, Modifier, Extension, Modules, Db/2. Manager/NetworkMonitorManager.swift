//
//  NetworkMonitorManager.swift
//  SecondEnglish
//
//  Created by kimhongpil on 2/21/24.
//

import Foundation
import Network
import Combine

// [Ref] https://www.youtube.com/watch?v=SY5ghtUdLZ4
final class NetworkMonitorManager {
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor
    
    static let shared: NetworkMonitorManager = NetworkMonitorManager()
    
    var isConnected: CurrentValueSubject<Bool, Never> = CurrentValueSubject(true)
    
    init() {
        monitor = NWPathMonitor()
        dump(monitor)
    }
    
    func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected.send(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
    
    func stopNetworkMonitoring() {
        monitor.cancel()
    }
}

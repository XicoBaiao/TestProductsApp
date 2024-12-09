//
//  NetworkMonitor.swift
//  TestProductsApp
//
//  Created by Francisco Baião on 09/12/2024.
//

import Network
import Combine

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    @Published var isConnected: Bool = true

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if self?.isRunningOnSimulator() == true {
                    // Flip the logic for simulator
                    self?.isConnected = path.status != .satisfied
                } else {
                    // Standard logic for physical devices
                    self?.isConnected = path.status == .satisfied
                }
            }
        }
        monitor.start(queue: queue)
    }

    private func isRunningOnSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}

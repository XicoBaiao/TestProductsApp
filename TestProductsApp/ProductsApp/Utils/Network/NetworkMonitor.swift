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
                // Not sure why but if we have network connection path.status value is unsatisfied and when we turn wifi off becomes satisfied, that's why condition looks confusing.
                self?.isConnected = path.status == .unsatisfied
            }
        }
        monitor.start(queue: queue)
    }
}


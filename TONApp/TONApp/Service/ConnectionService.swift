//
//  ConnectionService.swift
//  TONApp
//
//  Created by Aurocheg on 27.05.23.
//

import Foundation
import Network

protocol ConnectionServiceProtocol {
    func monitorNetwork() -> AsyncStream<Bool>
    func isConnected() -> Bool
}

final actor ConnectionService {
    static let shared: ConnectionService = .init()
    
    func monitorNetwork() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            let monitor = NWPathMonitor()

            monitor.pathUpdateHandler = { path in
                switch path.status {
                case .satisfied:
                    continuation.yield(true)
                case .unsatisfied, .requiresConnection:
                    continuation.yield(false)
                @unknown default:
                    continuation.yield(false)
                }
            }

            monitor.start(queue: DispatchQueue(label: "InternetConnectionMonitor"))
            
            continuation.onTermination = { _ in
                monitor.cancel()
            }
        }
    }
    func isConnected() async -> Bool {
        typealias Continuation = CheckedContinuation<Bool, Never>
        return await withCheckedContinuation({ (continuation: Continuation) in
            let monitor = NWPathMonitor()

            monitor.pathUpdateHandler = { path in
                monitor.cancel()
                switch path.status {
                case .satisfied:
                    continuation.resume(returning: true)
                case .unsatisfied, .requiresConnection:
                    continuation.resume(returning: false)
                @unknown default:
                    continuation.resume(returning: false)
                }
            }
            monitor.start(queue: DispatchQueue(label: "InternetConnectionMonitor"))
        })
    }
}

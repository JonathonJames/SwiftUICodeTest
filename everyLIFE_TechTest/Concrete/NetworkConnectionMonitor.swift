//
//  NetworkConnectionMonitor.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 01/09/2021.
//

import Network
import Combine

/// Describes connectivity the status of a network connection.
enum NetworkConnectionStatus {
    case unknown
    case connected
    case disconnected
}

typealias NetworkConnectionStatusTransition = PreviousCurrentPair<NetworkConnectionStatus>

struct PreviousCurrentPair<T> {
    private(set) var previous: T
    private(set) var current: T
    
    func updating(with newValue: T) -> PreviousCurrentPair<T> {
        return .init(previous: self.current, current: newValue)
    }
    
    mutating func update(with newValue: T) {
        self.previous = current
        self.current = newValue
    }
}



/// A class which can monitor
final class NetworkConnectionMonitor {
    private let monitor: NWPathMonitor = .init()
    private let queue: DispatchQueue = .init(label: "NetworkConnectionMonitor queue")
    private var state: NetworkConnectionStatus = .unknown
    
    @Published fileprivate(set) var transition: NetworkConnectionStatusTransition?

    init() {
        self.monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                #warning("TODO: Add logging")
                switch path.status {
                case .satisfied:
                    self.transition = .init(previous: self.state, current: .connected)
                    self.state = .connected
                case .requiresConnection, .unsatisfied:
                    self.transition = .init(previous: self.state, current: .disconnected)
                    self.state = .disconnected
                @unknown default:
                    self.transition = .init(previous: self.state, current: .unknown)
                    self.state = .unknown
                }
            }
        }
        self.monitor.start(queue: self.queue)
    }
}

extension NetworkConnectionMonitor: NetworkConnectionMonitorInterface {
    var status: AnyPublisher<NetworkConnectionStatusTransition?, Never> {
        return self.$transition.eraseToAnyPublisher()
    }
}

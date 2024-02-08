//
//  NetworkMonitor.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 06.02.2024.
//

import Foundation
import Combine
import Network

protocol NetworkMonitorProtocol {
	var isConnected: AnyPublisher<Bool, Never> { get }
	func startMonitoring()
	func stopMonitoring()
}

class NetworkMonitor: NetworkMonitorProtocol, ObservableObject {
	private var monitor: NWPathMonitor?
	private let queue = DispatchQueue(label: "NetworkMonitor")
	
	@Published private var _isConnected: Bool = true
	
	var isConnected: AnyPublisher<Bool, Never> {
		$_isConnected.eraseToAnyPublisher()
	}

	func startMonitoring() {
		guard monitor == nil else { return }

		monitor = NWPathMonitor()
		monitor?.pathUpdateHandler = { [weak self] path in
			DispatchQueue.main.async {
				self?._isConnected = path.status == .satisfied
			}
		}
		monitor?.start(queue: queue)
	}

	func stopMonitoring() {
		monitor?.cancel()
		monitor = nil
	}
	
	deinit {
		stopMonitoring()
	}
}

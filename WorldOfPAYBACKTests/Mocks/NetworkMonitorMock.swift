//
//  NetworkMonitorMock.swift
//  WorldOfPAYBACKTests
//
//  Created by Andrey Lebedev on 08.02.2024.
//

import Foundation
import Combine
@testable import WorldOfPAYBACK

class NetworkMonitorMock: NetworkMonitorProtocol {
	let isConnectedSubject = PassthroughSubject<Bool, Never>()
	var startMonitoringCalled = false
	var stopMonitoringCalled = false
	
	var isConnected: AnyPublisher<Bool, Never> {
		isConnectedSubject.eraseToAnyPublisher()
	}
	
	func startMonitoring() {
		startMonitoringCalled = true
	}
	
	func stopMonitoring() {
		stopMonitoringCalled = true
	}
}

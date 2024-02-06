//
//  PBTApiProtocol.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 06.02.2024.
//

import Foundation

enum PBTApiError: Error {
	case undefined
}

protocol PBTApiProtocol {
	func loadRequest(_ urlRequest: URLRequest) async throws -> Data
}

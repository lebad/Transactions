//
//  TransactionsServiceProtocol.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 06.02.2024.
//

import Foundation

enum TransactionsServiceError: Error {
	case undefined
}

protocol TransactionsServiceProtocol {
	func requestTransactions() async throws -> [Transaction]
}

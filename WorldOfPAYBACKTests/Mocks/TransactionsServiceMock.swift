//
//  TransactionsServiceMock.swift
//  WorldOfPAYBACKTests
//
//  Created by Andrey Lebedev on 08.02.2024.
//

import Foundation
@testable import WorldOfPAYBACK

class TransactionsServiceMock: TransactionsServiceProtocol {
	var transactions: [Transaction] = []
	var error: TransactionsServiceError?
	
	func requestTransactions() async throws -> [Transaction] {
		if let error {
			throw error
		}
		return transactions
	}
}

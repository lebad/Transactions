//
//  Transaction.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 06.02.2024.
//

import Foundation

struct Transaction: Equatable {
	let id: UUID
	let partnerDisplayName: String
	let transactionDetail: TransactionDetail
	let category: Int
	
	struct TransactionDetail: Equatable {
		struct Value: Equatable {
			let amount: Decimal
			let currency: String
		}
		
		let description: String?
		let bookingDate: Date
		let value: Value
	}
}

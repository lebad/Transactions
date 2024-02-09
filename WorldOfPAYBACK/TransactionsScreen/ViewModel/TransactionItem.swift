//
//  TransactionItem.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 06.02.2024.
//

import Foundation

// Data to display
struct TransactionItem: Identifiable, Equatable {
	let id: UUID
	let name: String
	let description: String?
	let bookingDateString: String
	let amountString: String
	let category: Int
}

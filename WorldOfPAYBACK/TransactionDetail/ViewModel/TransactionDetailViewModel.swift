//
//  TransactionDetailViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 07.02.2024.
//

import Foundation

class TransactionDetailViewModel: ObservableObject {
	let partnerDisplayName: String
	let transactionDescription: String?
	
	@Published var screenTitle = ""
	@Published var partnerText = ""
	@Published var descriptionText: String?
	
	init(partnerDisplayName: String, transactionDescription: String?) {
		self.partnerDisplayName = partnerDisplayName
		self.transactionDescription = transactionDescription
	}
	
	func start() {
		screenTitle = "Transaction Details"
		partnerText = "Partner: \(partnerDisplayName)"
		if let transactionDescription {
			descriptionText = "Description: \(transactionDescription)"
		}
	}
}

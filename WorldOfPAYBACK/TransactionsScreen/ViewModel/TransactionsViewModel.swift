//
//  TransactionsViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 06.02.2024.
//

import Foundation

@MainActor
class TransactionsViewModel: ObservableObject {
	@Published var screenTitle = ""
	@Published var transactionItems: [TransactionItem] = []
	
	private lazy var dateScreenFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yy, h:mm a"
		dateFormatter.amSymbol = "AM"
		dateFormatter.pmSymbol = "PM"
		return dateFormatter
	}()
	
	private lazy var numberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		return formatter
	}()
	
	private let transactionsService: TransactionsServiceProtocol
	
	init(transactionsService: TransactionsServiceProtocol) {
		self.transactionsService = transactionsService
	}
	
	func start() async {
		screenTitle = "Transactions"
		do {
			let transacions = try await transactionsService.requestTransactions()
			transactionItems = transacions
				.sorted(by: { $0.transactionDetail.bookingDate < $1.transactionDetail.bookingDate })
				.map { transaction in
				numberFormatter.currencyCode = transaction.transactionDetail.value.currency
				let amountString = numberFormatter.string(for: transaction.transactionDetail.value.amount) ?? ""
				let bookingDateString = dateScreenFormatter.string(from: transaction.transactionDetail.bookingDate)
				return TransactionItem(
					id: transaction.id,
					name: transaction.partnerDisplayName,
					description: transaction.transactionDetail.description,
					bookingDateString: "BookingDate: \(bookingDateString)",
					amountString: "Amount: \(amountString)"
				)
			}
		} catch  {
			print(error)
		}
	}
}

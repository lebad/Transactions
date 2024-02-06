//
//  TransactionsServiceFake.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 06.02.2024.
//

import Foundation

class TransactionsServiceFake: TransactionsServiceProtocol {
	private lazy var dateServerFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		return dateFormatter
	}()
	
	func requestTransactions() async throws -> [Transaction] {
		guard let data = fileData(file: "PBTransactions", fileType: "json") else {
			throw TransactionsServiceError.undefined
		}
		do {
			let serverData = try JSONDecoder().decode(TransactionItemsServerData.self, from: data)
			return try serverData.items.map { transaction in
				let bookingDateString = transaction.transactionDetail.bookingDate
				guard let dateServerDate = dateServerFormatter.date(from: bookingDateString) else {
					throw TransactionsServiceError.undefined
				}
				let amountInt = transaction.transactionDetail.value.amount
				let amount = Decimal(amountInt)
				let detail = Transaction.TransactionDetail(
					description: transaction.transactionDetail.description,
					bookingDate: dateServerDate,
					value: Transaction.TransactionDetail.Value(
						amount: amount,
						currency: transaction.transactionDetail.value.currency
					)
				)
				return Transaction(
					id: UUID(),
					partnerDisplayName: transaction.partnerDisplayName,
					transactionDetail: detail
				)
			}
		} catch {
			throw TransactionsServiceError.undefined
		}
	}
	
	private func fileData(file: String, fileType: String) -> Data? {
		let classType = type(of: self)
		let bundle: Bundle = Bundle(for: classType)
		guard let path = bundle.path(forResource: file, ofType: fileType),
			  let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
			return nil
		}
		return data
	}
}

private struct TransactionItemsServerData: Decodable {
	struct Transaction: Decodable {
		struct TransactionDetail: Decodable {
			struct Value: Decodable {
				let amount: Int
				let currency: String
			}
			
			let description: String?
			let bookingDate: String
			let value: Value
		}
		
		let partnerDisplayName: String
		let transactionDetail: TransactionDetail
	}
	
	let items: [Transaction]
}

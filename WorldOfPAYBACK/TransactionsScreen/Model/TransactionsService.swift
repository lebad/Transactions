//
//  TransactionsService.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 06.02.2024.
//

import Foundation

class TransactionsService: TransactionsServiceProtocol {
	private lazy var dateServerFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		return dateFormatter
	}()
	
	private let pbtApi: PBTApiProtocol
	
	init(pbtApi: PBTApiProtocol) {
		self.pbtApi = pbtApi
	}
	
	func requestTransactions() async throws -> [Transaction] {
		guard let url = URL(string: "https://api-test.payback.com/transactions") else {
			throw TransactionsServiceError.undefined
		}
		let urlRequest = URLRequest(url: url)
		guard let data = try? await pbtApi.loadRequest(urlRequest) else {
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
					transactionDetail: detail,
					category: transaction.category
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
		let category: Int
	}
	
	let items: [Transaction]
}

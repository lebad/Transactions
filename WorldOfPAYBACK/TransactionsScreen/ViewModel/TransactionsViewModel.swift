//
//  TransactionsViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 06.02.2024.
//

import Foundation
import Combine

struct AlertItem {
	var title = ""
	var message = ""
	var buttonTitle = ""
}

struct CategoryItem: Identifiable {
	let id: Int
	let name: String
}

@MainActor
class TransactionsViewModel: ObservableObject {
	@Published var screenTitle = ""
	@Published var isLoading = false
	@Published var shouldShowAlert = false
	@Published var alertItem = AlertItem()
	@Published var isNetworkConnected: Bool = true
	@Published var transactionItems: [TransactionItem] = []
	@Published var filteredTransactionItems: [TransactionItem] = []
	@Published var categories: [CategoryItem] = []
	@Published var selectedCategory = 0
	@Published var transactionsSumTitle: String?
	
	private var transactions: [Transaction] = []
	private var cancellables = Set<AnyCancellable>()
	
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
	private let networkMonitor: NetworkMonitorProtocol
	
	init(
		transactionsService: TransactionsServiceProtocol,
		networkMonitor: NetworkMonitorProtocol
	) {
		self.transactionsService = transactionsService
		self.networkMonitor = networkMonitor
	}
	
	func start() async {
		setupNetworkMonitor()
		setupSelectedCategory()
		screenTitle = "Transactions"
		isLoading = true
		await requestTransactions()
		isLoading = false
	}
	
	private func setupNetworkMonitor() {
		networkMonitor.isConnected
			.assign(to: &$isNetworkConnected)
		networkMonitor.startMonitoring()
	}
	
	private func setupSelectedCategory() {
		$selectedCategory
			.sink { [weak self] category in
				self?.filterTransactions(by: category)
				self?.setupTransactionsSum()
			}
			.store(in: &cancellables)
	}
	
	private func filterTransactions(by category: Int) {
		if category != 0 {
			filteredTransactionItems = transactionItems.filter { $0.category == category }
		} else {
			filteredTransactionItems = transactionItems
		}
	}
	
	private func requestTransactions() async {
		do {
			transactions = try await transactionsService.requestTransactions()
			transactionItems = transactions
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
					amountString: "Amount: \(amountString)", 
					category: transaction.category
				)
			}
			filteredTransactionItems = transactionItems
			setupCategories(from: transactions)
			setupTransactionsSum()
		} catch  {
			alertItem.title = "Error"
			alertItem.message = "Something went wrong. Please try again."
			alertItem.buttonTitle = "OK"
			shouldShowAlert = true
		}
	}
	
	private func setupCategories(from transacions: [Transaction]) {
		let categoryInts = Array(Set(transacions.map { $0.category }))
		let serverCategories = categoryInts
			.sorted()
			.map { CategoryItem(id: $0, name: "Category \($0)") }
		categories = [CategoryItem(id: 0, name: "All")] + serverCategories
	}
	
	private func setupTransactionsSum() {
		let sum = transactions
			.filter { transaction in filteredTransactionItems.contains(where: { $0.id == transaction.id }) }
			.reduce(0, { $0 + $1.transactionDetail.value.amount })
		guard let sumString = numberFormatter.string(for: sum) else {
			return
		}
		if sum > 0 {
			transactionsSumTitle = "Transactions Sum: \(sumString)"
		}
	}
}

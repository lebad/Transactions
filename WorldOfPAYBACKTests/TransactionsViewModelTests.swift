//
//  TransactionsViewModelTests.swift
//  WorldOfPAYBACKTests
//
//  Created by Andrey Lebedev on 08.02.2024.
//

import XCTest
import Combine
@testable import WorldOfPAYBACK

@MainActor
final class TransactionsViewModelTests: XCTestCase {
	var transactionsServiceMock: TransactionsServiceMock!
	var networkMonitorMock: NetworkMonitorMock!
	var transactionsStorageFake: TransactionsStorageFake!
	var viewModel: TransactionsViewModel!
	
	var cancellables = Set<AnyCancellable>()
	
	override func setUp() {
		super.setUp()
		transactionsServiceMock = TransactionsServiceMock()
		networkMonitorMock = NetworkMonitorMock()
		transactionsStorageFake = TransactionsStorageFake()
		viewModel = TransactionsViewModel(
			transactionsService: transactionsServiceMock,
			networkMonitor: networkMonitorMock,
			transactionsStorage: transactionsStorageFake,
			localeId: TestData.localeId
		)
	}
	
	func test_start_shouldDoMainLogic() async {
		// arrange
		transactionsServiceMock.transactions = TestData.transactions
		var isLoadingArray: [Bool] = []
		viewModel.$isLoading
			.sink { isLoading in
				isLoadingArray.append(isLoading)
			}
			.store(in: &cancellables)
		
		// act
		await viewModel.start()
		
		// assert
		XCTAssertTrue(networkMonitorMock.startMonitoringCalled)
		XCTAssertEqual(viewModel.screenTitle, "Transactions")
		XCTAssertEqual(viewModel.categoryTitle, "Select Category")
		XCTAssertEqual(isLoadingArray, TestData.expectedIsLoading)
		XCTAssertEqual(transactionsStorageFake.transactions, TestData.transactions)
		XCTAssertEqual(viewModel.filteredTransactionItems, TestData.expectedTransactionItems)
		XCTAssertEqual(viewModel.categories, TestData.expectedCategories)
		XCTAssertEqual(viewModel.transactionsSumTitle, "Transactions Sum: PBP 1,364.00")
	}
	
	func test_start_whenRequestTransactionsFail_shouldShowAlert() async {
		// arrange
		transactionsServiceMock.error = .undefined
		
		// act
		await viewModel.start()
		
		// assert
		XCTAssertEqual(viewModel.alertItem, TestData.expectedAlertItem)
		XCTAssertTrue(viewModel.shouldShowAlert)
	}
	
	func test_start_whenFilterCategory_shouldShowFilteredResults() async {
		// arrange
		transactionsServiceMock.transactions = TestData.transactions
		await viewModel.start()
		
		// act
		viewModel.selectedCategory = 1
		
		// assert
		XCTAssertEqual(viewModel.filteredTransactionItems, TestData.expectedTransactionItems.filter { $0.category == 1 })
	}
	
	func test_start_whenNetworkNotConnected_shouldShowNotConnected() async {
		// arrange
		transactionsServiceMock.transactions = TestData.transactions
		await viewModel.start()
		
		// act
		networkMonitorMock.isConnectedSubject.send(false)
		
		// assert
		XCTAssertFalse(viewModel.isNetworkConnected)
	}
}

extension TransactionsViewModelTests {
	enum TestData {
		static let localeId = "en_US"
		static let expectedIsLoading = [false, true, false]
		static let transactions: [Transaction] = [
			Transaction(
				id: UUID(),
				partnerDisplayName: "dm-dogerie markt",
				transactionDetail: Transaction.TransactionDetail(
					description: "Punkte sammeln",
					bookingDate: Date(timeIntervalSince1970: 1707407003),
					value: Transaction.TransactionDetail.Value(
						amount: 1240,
						currency: "PBP"
					)
				),
				category: 2
			),
			Transaction(
				id: UUID(),
				partnerDisplayName: "REWE Group",
				transactionDetail: Transaction.TransactionDetail(
					description: "Punkte sammeln",
					bookingDate: Date(timeIntervalSince1970: 1707406806),
					value: Transaction.TransactionDetail.Value(
						amount: 124,
						currency: "PBP"
					)
				),
				category: 1
			)
		]
		static let expectedTransactionItems: [TransactionItem] = [
			TransactionItem(
				id: transactions[1].id,
				name: "REWE Group",
				description: "Punkte sammeln",
				bookingDateString: "BookingDate: 02/08/24, 7:40 PM",
				amountString: "Amount: PBP 124.00",
				category: 1
			),
			TransactionItem(
				id: transactions[0].id,
				name: "dm-dogerie markt",
				description: "Punkte sammeln",
				bookingDateString: "BookingDate: 02/08/24, 7:43 PM",
				amountString: "Amount: PBP 1,240.00",
				category: 2
			)
		]
		static let expectedCategories: [CategoryItem] = [
			CategoryItem(id: 0, name: "All"),
			CategoryItem(id: 1, name: "Category 1"),
			CategoryItem(id: 2, name: "Category 2"),
		]
		static let expectedAlertItem = AlertItem(
			title: "Error",
			message: "Something went wrong. Please try again.",
			buttonTitle: "OK"
		)
	}
}

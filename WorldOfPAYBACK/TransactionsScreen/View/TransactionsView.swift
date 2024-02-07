//
//  TransactionsView.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 06.02.2024.
//

import SwiftUI

struct TransactionsView: View {
	@StateObject var viewModel: TransactionsViewModel
	
	var body: some View {
		NavigationStack {
			VStack {
				if viewModel.isLoading {
					ProgressView()
				} else {
					if !viewModel.isNetworkConnected {
						ConnectionStatusView()
					}
					Picker("Select Category", selection: $viewModel.selectedCategory) {
						ForEach(viewModel.categories) { category in
							Text(category.name).tag(category.id as Int?)
						}
					}
					.pickerStyle(SegmentedPickerStyle())
					.padding()
					if let transactionsSumTitle = viewModel.transactionsSumTitle {
						Text(transactionsSumTitle)
							.font(.headline)
					}
					List(viewModel.filteredTransactionItems) { transactionItem in
						NavigationLink {
							TransactionDetailFactory()
								.make(
									partnerDisplayName: transactionItem.name,
									transactionDescription: transactionItem.description
								)
						} label: {
							VStack(alignment: .leading, spacing: 4) {
								Text(transactionItem.name)
									.font(.headline)
								transactionItem.description.map {
									Text($0)
										.font(.subheadline)
								}
								Text(transactionItem.bookingDateString)
									.font(.body)
								Text(transactionItem.amountString)
									.font(.body)
							}
						}
					}
					.navigationBarTitle(viewModel.screenTitle, displayMode: .inline)
				}
			}
		}
		.alert(isPresented: $viewModel.shouldShowAlert) {
			Alert(
				title: Text(viewModel.alertItem.title),
				message: Text(viewModel.alertItem.message),
				dismissButton: .default(Text(viewModel.alertItem.buttonTitle))
			)
		}
		.onViewDidLoad {
			Task {
				await viewModel.start()
			}
		}
	}
}

// MARK: Preview

class TransactionsServicePreviewFake: TransactionsServiceProtocol {
	func requestTransactions() async throws -> [Transaction] { [] }
}

extension TransactionsViewModel {
	static var preview: TransactionsViewModel {
		let viewModel = TransactionsViewModel(transactionsService: TransactionsServicePreviewFake(), networkMonitor: NetworkMonitor())
		viewModel.screenTitle = "Transactions"
		viewModel.transactionItems = [
			TransactionItem(
				id: UUID(),
				name: "REWE Group",
				description: "Punkte sammeln",
				bookingDateString: "Booking date: 01.02.14",
				amountString: "Amount: 124 PBP", 
				category: 1
			),
			TransactionItem(
				id: UUID(),
				name: "OTTO Group",
				description: "Punkte sammeln",
				bookingDateString: "Booking date: 01.02.14",
				amountString: "Amount: 32 PBP", 
				category: 2
			)
		]
		return viewModel
	}
}

#Preview {
	TransactionsView(viewModel: TransactionsViewModel.preview)
}

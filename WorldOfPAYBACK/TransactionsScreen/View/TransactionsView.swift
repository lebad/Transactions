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
			if viewModel.isLoading {
				ProgressView()
			} else {
				List(viewModel.transactionItems) { transactionItem in
					NavigationLink(value: transactionItem.id) {
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
				.navigationTitle(viewModel.screenTitle)
				.navigationBarTitleDisplayMode(.inline)				
			}
		}
		.alert(isPresented: $viewModel.shouldShowAlert) {
			Alert(
				title: Text(viewModel.alertItem.title),
				message: Text(viewModel.alertItem.message),
				dismissButton: .default(Text(viewModel.alertItem.buttonTitle))
			)
		}
		.task {
			await viewModel.start()
		}
    }
}

// MARK: Preview

class TransactionsServicePreviewFake: TransactionsServiceProtocol {
	func requestTransactions() async throws -> [Transaction] { [] }
}

extension TransactionsViewModel {
	static var preview: TransactionsViewModel {
		let viewModel = TransactionsViewModel(transactionsService: TransactionsServicePreviewFake())
		viewModel.screenTitle = "Transactions"
		viewModel.transactionItems = [
			TransactionItem(
				id: UUID(),
				name: "REWE Group",
				description: "Punkte sammeln",
				bookingDateString: "Booking date: 01.02.14",
				amountString: "Amount: 124 PBP"
			),
			TransactionItem(
				id: UUID(),
				name: "OTTO Group",
				description: "Punkte sammeln",
				bookingDateString: "Booking date: 01.02.14",
				amountString: "Amount: 32 PBP"
			)
		]
		return viewModel
	}
}

#Preview {
	TransactionsView(viewModel: TransactionsViewModel.preview)
}

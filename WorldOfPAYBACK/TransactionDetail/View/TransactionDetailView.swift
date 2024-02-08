//
//  TransactionDetailView.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 07.02.2024.
//

import SwiftUI

struct TransactionDetailView: View {
	@StateObject var viewModel: TransactionDetailViewModel

	var body: some View {
		HStack {
			VStack {
				VStack(alignment: .leading, spacing: 20) {
					Text(viewModel.partnerText)
						.font(.title)
					if let descriptionText = viewModel.descriptionText {
						Text(descriptionText)
							.font(.body)
					}
				}
				Spacer()
			}
			Spacer()
		}
		.padding()
		.navigationBarTitle(viewModel.screenTitle, displayMode: .inline)
		.onAppear {
			viewModel.start()
		}
	}
}

#Preview {
	TransactionDetailView(
		viewModel: TransactionDetailViewModel(
			partnerDisplayName: "partnerDisplayName",
			transactionDescription: "transactionDescription"
		)
	)
}

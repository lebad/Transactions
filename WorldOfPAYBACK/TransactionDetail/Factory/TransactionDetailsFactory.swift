//
//  TransactionDetailFactory.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 07.02.2024.
//

import Foundation
import SwiftUI

class TransactionDetailFactory {
	func make(partnerDisplayName: String, transactionDescription: String?) -> some View {
		TransactionDetailView(
			viewModel: TransactionDetailViewModel(
				partnerDisplayName: partnerDisplayName,
				transactionDescription: transactionDescription
			)
		)
	}
}

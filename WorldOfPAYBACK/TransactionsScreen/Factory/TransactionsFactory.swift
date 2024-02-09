//
//  TransactionsFactory.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 08.02.2024.
//

import Foundation
import SwiftUI

@MainActor
class TransactionsFactory {
	func make() -> some View {
		let service = TransactionsService(
			pbtApi: PBTApiLocalMock(),
			hostResolver: HostResolver()
		)
		let viewModel = TransactionsViewModel(
			transactionsService: service,
			networkMonitor: NetworkMonitor(), 
			transactionsStorage: TransactionsStorage.shared,
			localeId: Locale.current.identifier
		)
		return TransactionsView(viewModel: viewModel)
	}
}

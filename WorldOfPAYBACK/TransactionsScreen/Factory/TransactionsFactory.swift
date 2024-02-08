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
			networkMonitor: NetworkMonitor()
		)
		return TransactionsView(viewModel: viewModel)
	}
}

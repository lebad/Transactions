//
//  TransactionsStorageFake.swift
//  WorldOfPAYBACKTests
//
//  Created by Andrey Lebedev on 08.02.2024.
//

import Foundation
@testable import WorldOfPAYBACK

class TransactionsStorageFake: TransactionsStorageProtocol {
	var transactions: [Transaction] = []
}

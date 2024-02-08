//
//  TransactionsStorage.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 08.02.2024.
//

import Foundation

protocol TransactionsStorageProtocol {
	var transactions: [Transaction] { get set }
}

class TransactionsStorage: TransactionsStorageProtocol {
	private var _transactions: [Transaction] = []
	
	static let shared = TransactionsStorage()
	
	private init() {}
	
	var transactions: [Transaction] {
		get {
			_transactions
		}
		set {
			_transactions = newValue
		}
	}
}

//
//  PBTApiLocalMock.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 06.02.2024.
//

import Foundation

class PBTApiLocalMock: PBTApiProtocol {
	func loadRequest(_ urlRequest: URLRequest) async throws -> Data {
		guard let data = fileData(file: "PBTransactions", fileType: "json") else {
			throw PBTApiError.undefined
		}
		try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
		let isSuccess = Bool.random()
		if !isSuccess {
			throw PBTApiError.undefined
		}
		return data
	}
	
	private func fileData(file: String, fileType: String) -> Data? {
		let classType = type(of: self)
		let bundle: Bundle = Bundle(for: classType)
		guard let path = bundle.path(forResource: file, ofType: fileType),
			  let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
			return nil
		}
		return data
	}
}

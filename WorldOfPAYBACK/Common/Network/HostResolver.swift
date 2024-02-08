//
//  HostResolver.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 08.02.2024.
//

import Foundation

protocol HostResolverProtocol {
	var currentHost: String { get }
}

class HostResolver: HostResolverProtocol {
	var currentHost: String {
		#if PRODUCTION
		let host = "api.payback.com"
		#elseif TEST
		let host = "api-test.payback.com"
		#else
		let host = "api-test.payback.com"
		#endif
		return host
	}
}

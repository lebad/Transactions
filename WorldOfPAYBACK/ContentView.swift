//
//  ContentView.swift
//  WorldOfPAYBACK
//
//  Created by Andrey Lebedev on 05.02.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		TransactionsFactory().make()
    }
}

#Preview {
    ContentView()
}

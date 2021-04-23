//
//  ForexApp.swift
//  Forex
//
//  Created by Subedi, Rikesh on 14/01/21.
//

import SwiftUI

@main
struct ForexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeScreen(viewModel: HomeScreenViewModel(repository: ExchangeRepository(persistentController: PersistenceController())))
        }
    }
}

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

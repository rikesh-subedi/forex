//
//  ExchangeResponse.swift
//  Forex
//
//  Created by Subedi, Rikesh on 14/01/21.
//

import SwiftUI
import Combine
struct ExchangeResponse: Codable {
    var timestamp: Int64
    var source: String
    var quotes: [String: Float]
}

final class ExchangeResponseObservable: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    @Published var exchangeResponse: ExchangeResponse? {
        willSet {
            self.objectWillChange.send()
        }
    }

    @Published var error: Error? {
        willSet {
            self.objectWillChange.send()
        }
    }
}

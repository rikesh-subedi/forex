//
//  ExchangeRepositoryInterface.swift
//  Forex
//
//  Created by Subedi, Rikesh on 18/01/21.
//

import SwiftUI
import Combine
protocol ExchangeRepositoryInterface {
    func fetchExchanges(src: String, tryCached: Bool) -> Future<ExchangeResponse, Error>
}

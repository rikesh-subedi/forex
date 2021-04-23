//
//  HomeScreenViewModel.swift
//  Forex
//
//  Created by Subedi, Rikesh on 14/01/21.
//

import Combine
import SwiftUI

final class HomeScreenViewModel: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    let initialSrc = "USD"
    private var exchangeRepository : ExchangeRepositoryInterface
    var timer: Timer?
    init(repository: ExchangeRepositoryInterface) {
        exchangeRepository = repository
        timer = Timer.scheduledTimer(timeInterval: 30 * 60, target: self, selector: #selector(timerExecuted), userInfo: nil, repeats: true)
    }
    var cancellationToken: AnyCancellable?
    var originalExchanges: [String: Float]?
    @Published var exchanges: [String: Float]? {
        willSet {
            self.objectWillChange.send()
        }
    }

    @Published var currencyList: [String] = [] {
        willSet {
            self.objectWillChange.send()
        }
    }

    @objc func timerExecuted() {
        fetchExchanges(src: "USD", tryCached: false)
    }

    func fetchExchanges(src: String, tryCached: Bool = true) {
        if src != initialSrc {
            //current api subscription does not support switch
            //I am locally switching
            switchSourceTo(src: src)
        } else {
            cancellationToken = exchangeRepository
                .fetchExchanges(src: src, tryCached: tryCached)
                .sink(receiveCompletion: { (error) in
                    print(error)
                }, receiveValue: { (response) in
                    self.originalExchanges = response.quotes
                    self.exchanges = response.quotes
                    self.currencyList = response.quotes.keys.sorted().map({ (key) -> String in
                        return String(key.suffix(key.count - src.count))
                    })


                })
        }

    }

    func switchSourceTo(src: String) {

        var newQuotes = [String:Float]()
        if let quotes = originalExchanges, let exchangeRate = quotes["\(initialSrc)\(src)".uppercased()] {
            let newExchangeRate = 1 / exchangeRate
            newQuotes["\(src)\(initialSrc)".uppercased()] = newExchangeRate
            quotes.keys.sorted().forEach { (key) in
                let keySuffix = "" + key.suffix(key.count - initialSrc.count)
                if src != keySuffix {
                    let newKey = (src + keySuffix).uppercased()
                    let value = (quotes[key] ?? 0.0) * newExchangeRate
                    newQuotes[newKey] = value
                }

            }

            self.exchanges = newQuotes
        }
    }
}

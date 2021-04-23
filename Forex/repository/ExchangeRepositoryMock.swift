//
//  ExchangeRepositoryMock.swift
//  ForexTests
//
//  Created by Subedi, Rikesh on 18/01/21.
//
import SwiftUI
import Combine

class ExchangeRepositoryMock: ExchangeRepositoryInterface {
    func fetchExchanges(src: String, tryCached: Bool = true) -> Future<ExchangeResponse, Error> {
        let testString = """
                        {
                          "success":true,
                          "terms":"https://currencylayer.com/terms",
                          "privacy":"https://currencylayer.com/privacy",
                          "timestamp":1610522467,
                          "source":"USD",
                          "quotes":{
                            "USDAED":3.67296,
                            "USDAFN":76.648892,
                            "USDALL":101.047221,
                            "USDAMD":525.440589,
                            "USDANG":1.785228,
                            "USDAOA":657.502029
                          }
                        }
        """
        let exchangeResponse = try? JSONDecoder().decode(ExchangeResponse.self, from: testString.data(using: String.Encoding.utf8)!)
        let future = Future<ExchangeResponse, Error>.init { promise in
            promise(.success(exchangeResponse!))
        }
        return future
    }
}

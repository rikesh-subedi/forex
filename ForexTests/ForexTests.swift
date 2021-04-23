//
//  ForexTests.swift
//  ForexTests
//
//  Created by Subedi, Rikesh on 14/01/21.
//

import XCTest
@testable import Forex

class ForexTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testExhchangeResponseCodable() throws {
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
        XCTAssert(exchangeResponse != nil)
        XCTAssert(exchangeResponse!.source == "USD")
        XCTAssert(exchangeResponse!.timestamp == 1610522467)
        XCTAssert(exchangeResponse!.quotes.count == 6)
    }

}

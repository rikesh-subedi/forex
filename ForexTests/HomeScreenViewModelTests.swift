//
//  HomeScreenViewModelTests.swift
//  ForexTests
//
//  Created by Subedi, Rikesh on 18/01/21.
//

import XCTest
@testable import Forex

class HomeScreenViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchExchanges() throws {
        let viewModel = HomeScreenViewModel(repository: ExchangeRepositoryMock())
        viewModel.fetchExchanges(src: "USD")
        XCTAssert(viewModel.currencyList.count == 6 )
        XCTAssert(viewModel.exchanges?["USDAED"] != nil)
        XCTAssert(viewModel.exchanges!["USDAED"] == 3.67296)
    }

    func testSwitchSource() throws {
        let viewModel = HomeScreenViewModel(repository: ExchangeRepositoryMock())
        viewModel.fetchExchanges(src: "USD")
        viewModel.switchSourceTo(src: "AED")
        XCTAssert(viewModel.exchanges?["AEDUSD"] != nil)
        XCTAssert(viewModel.exchanges!["AEDUSD"] == 0.27225998 )
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

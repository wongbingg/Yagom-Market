//
//  SearchProductDetailAPITest.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2022/11/15.
//

import XCTest
@testable import YagomMarket

final class SearchProductDetailAPITest: XCTestCase {
    var sut: SearchProductDetailAPI!
    
    override func setUpWithError() throws {
        let productId = 179
        let apiConfig = APIConfiguration(method: .get,
                                         base: URLCommand.host,
                                         path: URLCommand.products + "/\(productId)",
                                         parameters: nil)
        sut = SearchProductDetailAPI(configuration: apiConfig)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_productDetail이_response로_받아와지는지() {
        // given
        var response: SearchProductDetailResponse?
        let expectation = XCTestExpectation(description: "API Response Test")
        
        // when
        sut.execute { result in
            switch result {
            case .success(let result):
                print(result)
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
        }
        wait(for: [expectation], timeout: 5.0)
        
        // then
        XCTAssertNotNil(expectation)
    }
}
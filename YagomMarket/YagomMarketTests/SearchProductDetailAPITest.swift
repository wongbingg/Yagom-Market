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
        try super.setUpWithError()
        sut = SearchProductDetailAPI(productId: 180)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_productDetail이_response로_받아와지는지() {
        // given
        var response: SearchProductDetailResponse?
        let expectation = XCTestExpectation(description: "Search Product Detail Test")
        
        // when
        sut.execute { result in
            switch result {
            case .success(let fetchedData):
                response = fetchedData
                print(fetchedData)
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
        }
        wait(for: [expectation], timeout: 5.0)
        
        // then
        XCTAssertNotNil(response)
    }
}

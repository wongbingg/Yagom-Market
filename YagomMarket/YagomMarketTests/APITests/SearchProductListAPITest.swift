//
//  SearchProductListAPITest.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2022/11/14.
//

import XCTest
@testable import YagomMarket

final class SearchProductListAPITest: XCTestCase {
    var sut: SearchProductListAPI!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SearchProductListAPI(
            pageNumber: 1,
            itemPerPage: 3,
            searchValue: "wongbing"
        )
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_productList를_GET으로_받아올수있는지() async throws {
        // given
        var response: ProductListResponseDTO?
        // when
        response = try await sut.execute()
        print(response!)
        // then
        XCTAssertNotNil(response)
    }
}

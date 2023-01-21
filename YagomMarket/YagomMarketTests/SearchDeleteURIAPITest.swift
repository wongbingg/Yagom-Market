//
//  SearchDeleteURIAPITest.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2022/11/16.
//

import XCTest
@testable import YagomMarket

final class SearchDeleteURIAPITest: XCTestCase {
    var sut: SearchDeleteURIAPI!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SearchDeleteURIAPI(productId: 1737)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_secretKey와rowData를이용해서_삭제uri를요청하면_잘받아와지는지() async throws {
        // given
        var response: String?
        // when
        response = try await sut.execute()
        print(response)
        // then
        XCTAssertNotNil(response)
    }
}

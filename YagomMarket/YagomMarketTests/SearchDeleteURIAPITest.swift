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
        sut = SearchDeleteURIAPI(productId: 278)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_secretKey와rowData를이용해서_삭제uri를요청하면_잘받아와지는지() {
        // given
        let expectation = XCTestExpectation(description: "Search DeleteURI Test")
        
        // when
        var response: String?
        sut.searchDeleteURI { result in
            switch result {
            case .success(let deleteURI):
                print(deleteURI)
                response = deleteURI
                expectation.fulfill()
            case .failure(let error):
                print(String(describing: error))
            }
        }
        wait(for: [expectation], timeout: 3.0)
        
        // then
        XCTAssertNotNil(response)
    }
}

//
//  SearchDeleteURIAPITest.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2022/11/16.
//

import XCTest
@testable import YagomMarket

final class SearchDeleteURIAPITest: XCTestCase {
    var sut: SearchDeleteURIAPI<DeleteProductAPI>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let apiConfig = APIConfiguration(
            method: .post,
            base: URLCommand.host,
            path: URLCommand.products +
            URLCommand.productId(delete: 278),
            body: DeleteKeyRequestModel(secret: URLCommand.secretKey),
            parameters: nil
        )
        sut = SearchDeleteURIAPI<DeleteProductAPI>(configuration: apiConfig)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_secretKey와rowData를이용해서_삭제uri를요청하면_잘받아와지는지() {
        // given
        let expectation = XCTestExpectation(description: "FindDeleteKey")
        
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

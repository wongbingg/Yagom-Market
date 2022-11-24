//
//  DeleteProductAPI.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2022/11/16.
//

import XCTest
@testable import YagomMarket

final class DeleteProductAPITest: XCTestCase {
    var sut: SearchDeleteURIAPI<DeleteProductAPI>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = makeAPI() as? SearchDeleteURIAPI
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_id에_해당하는상품이_삭제가_되는지() {
        // given
        let expectation = XCTestExpectation(description: "DeleteTest")
        var flag: Int?
        
        // when
        sut.searchDeleteURI { result in
            switch result {
            case .success(_):
                flag = 1
                expectation.fulfill()
            case .failure(_):
                print("test fail")
            }
        }
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(flag)
        // then
    }
    
    func makeAPI() -> any API {
        let deleteProductAPI = DeleteProductAPI()
        let apiConfig = APIConfiguration(
            method: .post,
            base: URLCommand.host,
            path: URLCommand.products +
            URLCommand.productId(delete: 207),
            parameters: nil
        )
        return SearchDeleteURIAPI(configuration: apiConfig, delegate: deleteProductAPI)
    }
}
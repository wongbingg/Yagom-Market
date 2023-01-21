//
//  DeleteProductAPI.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2022/11/16.
//

import XCTest
@testable import YagomMarket

final class DeleteProductAPITest: XCTestCase {
    var sut: SearchDeleteURIAPI!
    var sut2: DeleteProductAPI!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SearchDeleteURIAPI(productId: 1737)
        sut2 = DeleteProductAPI()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        sut2 = nil
    }
    
    func test_id에_해당하는상품이_삭제가_되는지() async throws {
        // given
        var deleteURI: String?
        var response: DeleteProductAPI.ResponseType?
        // when
        deleteURI = try await sut.execute()
        response = try await sut2.execute(with: deleteURI!)
        // then
        XCTAssertNotNil(deleteURI)
        XCTAssertNotNil(response)
    }
}

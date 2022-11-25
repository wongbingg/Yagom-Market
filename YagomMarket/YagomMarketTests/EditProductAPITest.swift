//
//  EditProductAPITest.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2022/11/24.
//

import XCTest
@testable import YagomMarket

final class EditProductAPITest: XCTestCase {
    var sut: EditProductAPI!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let model = EditProductModel(
            name: "미라클 모닝",
            description: "아침형 인간이 될 수 있는 절호의 기회! \n 키오에게 문의하기 📞",
            thumbnailId: nil,
            price: 12000,
            currency: .KRW,
            discountedPrice: nil,
            stock: 100,
            secret: URLCommand.secretKey
        )
        let apiConfig = APIConfiguration(
            method: .patch,
            base: URLCommand.host,
            path: URLCommand.products +
            URLCommand.productId(search: 277),
            body: model,
            parameters: nil,
            images: nil
        )
        sut = EditProductAPI(configuration: apiConfig)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_상품수정이_잘이루어지는지() {
        // given
        let expectation = XCTestExpectation(description: "PATCH TEST")
        var response: SearchProductDetailResponse?
        
        // when
        sut.execute { result in
            switch result {
            case .success(let success):
                response = success
                expectation.fulfill()
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
        
        // then
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(response)
    }
}

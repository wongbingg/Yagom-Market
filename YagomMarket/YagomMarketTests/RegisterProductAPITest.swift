//
//  RegisterProductAPITest.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2022/11/15.
//

import XCTest
@testable import YagomMarket

final class RegisterProductAPITest: XCTestCase {
    var sut: RegisterProductAPI!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let model = ProductModel(
            name: "테스트",
            description: "Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스",
            price: 1200,
            currency: .KRW,
            discountedPrice: nil,
            stock: 3,
            secret: URLCommand.secretKey
        )
        sut = RegisterProductAPI(postModel: model, images: [UIImage(named: "Photo")!])
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_원하는상품을_POST를통해_등록할수있는지() {
        // given
        var response: SearchProductDetailResponse?
        let expectation = XCTestExpectation(description: "Register Product Test")
        
        // when
        sut.execute { result in
            switch result {
            case .success(let fetchedResponse):
                print(fetchedResponse)
                response = fetchedResponse
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

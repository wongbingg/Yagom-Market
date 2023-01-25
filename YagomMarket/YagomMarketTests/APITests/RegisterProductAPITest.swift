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
        let model = ProductPostRequestDTO(
            name: "테스트",
            description: "Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스트용Post테스",
            price: 1200,
            currency: .KRW,
            discountedPrice: nil,
            stock: 3,
            secret: URLCommand.secretKey
        )
        let registerModel = RegisterModel(requestDTO: model, images: [UIImage(named: "Photo")!])
        sut = RegisterProductAPI(model: registerModel)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_원하는상품을_POST를통해_등록할수있는지() async throws {
        // given
        var response: ProductDetailResponseDTO?
        // when
        response = try await sut.execute()
        print(response!)
        // then
        XCTAssertNotNil(response)
    }
}

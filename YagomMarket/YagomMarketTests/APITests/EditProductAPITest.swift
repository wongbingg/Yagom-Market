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
        let model = ProductEditRequestDTO(
            name: "미라클 모닝",
            description: "아침형 인간이 될 수 있는 절호의 기회! \n 키오에게 문의하기 📞",
            thumbnailId: nil,
            price: 12000,
            currency: .KRW,
            discountedPrice: nil,
            stock: 100,
            secret: URLCommand.secretKey
        )
        sut = EditProductAPI(editModel: model, productId: 1737)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_상품수정이_잘이루어지는지() async throws {
        // given
        var response: ProductDetailResponseDTO?
        // when
        response = try await sut.execute()
        print(response)
        // then
        XCTAssertNotNil(response)
    }
}

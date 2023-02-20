//
//  EditProductUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

import XCTest
@testable import YagomMarket

final class EditProductUseCaseTests: XCTestCase {
    var sut: EditProductUseCase!
    var productRepositoryMock: ProductsRepositoryMock!
    
    override func setUpWithError() throws {
        productRepositoryMock = ProductsRepositoryMock()
        sut = DefaultEditProductUseCase(
            productsRepository: productRepositoryMock
        )
    }
    override func tearDownWithError() throws {
        productRepositoryMock = nil
        sut = nil
    }
    
    func test_실행했을때_productRepository의_editProductDetail메서드가실행되는지_productId를정확하게전달받는지() async throws {
        // given
        let expectationCallCount = 1
        let expectationPassedProductId = 10
        
        // when
        try await sut.execute(with: ProductEditRequestDTO.stub(), productId: 10)
        
        // then
        XCTAssertEqual(expectationCallCount, productRepositoryMock.editProductDetailCallCount)
        XCTAssertEqual(expectationPassedProductId, productRepositoryMock.passedProductId)
    }
}

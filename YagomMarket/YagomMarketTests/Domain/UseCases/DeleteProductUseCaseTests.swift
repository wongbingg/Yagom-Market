//
//  DeleteProductUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
@testable import YagomMarket

final class DeleteProductUseCaseTests: XCTestCase {
    
    func test_UseCase실행될때_ProductRepository의deleteProduct메서드가실행되는지() async throws {
        // given
        let expectationCallCount = 1
        let expectationProductId = 10
        let productRepository = ProductsRepositoryMock()
        let useCase = DefaultDeleteProductUseCase(productsRepository: productRepository)
        
        // when
        try await useCase.execute(productId: expectationProductId)
        
        // then
        XCTAssertEqual(expectationCallCount, productRepository.deleteMethodCallCount)
        XCTAssertEqual(expectationProductId, productRepository.passedProductId)
    }
}

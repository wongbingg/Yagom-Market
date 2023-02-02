//
//  FetchProductDetailUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
@testable import YagomMarket

final class FetchProductDetailUseCaseTests: XCTestCase {
    
    func test_UseCase실행될때_ProductRepository의_fetchProductDetail메서드가실행되는지() async throws {
        // given
        let expectationCallCount = 1
        let expectationProductId = 10
        let expectationResponse = ProductDetail.toMockData()
        let productRepository = ProductsRepositoryMock()
        let useCase = FetchProductDetailUseCase(productsRepository: productRepository)
        
        // when
        let response = try await useCase.execute(productId: expectationProductId)
        
        // then
        XCTAssertEqual(expectationCallCount, productRepository.fetchProductDetailMethodCallCount)
        XCTAssertEqual(expectationProductId, productRepository.passedProductId)
        XCTAssertEqual(expectationResponse, response)
    }
}

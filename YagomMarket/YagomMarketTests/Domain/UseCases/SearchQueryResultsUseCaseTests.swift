//
//  SearchQueryResultsUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
@testable import YagomMarket

final class SearchQueryResultsUseCaseTests: XCTestCase {
    
    func test_UseCase를실행할때_ProductRepository의_fetchProductList메서드가실행되는지() async throws {
        // given
        let expectationCallCount = 1
        let productsRepository = ProductsRepositoryMock()
        let useCase = DefaultSearchQueryResultsUseCase(productsRepository: productsRepository)
        
        // when
        _ = try await useCase.execute(keyword: "valid keyword")
        
        // then
        XCTAssertEqual(expectationCallCount, productsRepository.fetchProductsListCallCount)
    }
}

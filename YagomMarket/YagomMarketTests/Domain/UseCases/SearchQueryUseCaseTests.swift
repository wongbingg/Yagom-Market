//
//  SearchQueryUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
@testable import YagomMarket

final class SearchQueryUseCaseTests: XCTestCase {
    
    func test_UseCase실행시_ProductsRepository의_fetchProductsQuery메서드를실행하는지() async throws {
        // given
        let expectationCallCount = 1
        let productsRepository = ProductsRepositoryMock()
        let useCase = SearchQueryUseCase(productsRepository: productsRepository)
        
        // when
        
        _ = try await useCase.execute(keyword: "keyword")
        
        // then
        XCTAssertEqual(expectationCallCount, productsRepository.fetchProductsQueryCallCount)
    }
}

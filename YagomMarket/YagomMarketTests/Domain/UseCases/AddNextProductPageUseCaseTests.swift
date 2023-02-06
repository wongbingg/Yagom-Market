//
//  AddNextProductPageUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
@testable import YagomMarket

final class AddNextProductPageUseCaseTests: XCTestCase {
    
    func test_hasNext가true일때_값을성공적으로받아오는지() async throws {
        // given
        var response: [ProductCell]?
        let productRepository = ProductsRepositoryMock()
        let useCase = DefaultAddNextProductPageUseCase(productsRepository: productRepository)
        
        // when
        response = try await useCase.execute()
        
        // then
        XCTAssertNotNil(response)
    }
    
    func test_hasNext가false일때_noHasNext오류를반환하는지() async throws {
        // given
        let expectationError = ProductsRepositoryError.noNextPage
        let productRepository = ProductsRepositoryMock()
        productRepository.hasNext = false
        let useCase = DefaultAddNextProductPageUseCase(productsRepository: productRepository)
        
        // when
        _ = try await useCase.execute() // hasNext 가 false로 변경
        
        // then
        do {
            _ = try await useCase.execute()
            XCTFail()
        } catch let error as ProductsRepositoryError {
            XCTAssertEqual(error, expectationError)
        }
    }
}

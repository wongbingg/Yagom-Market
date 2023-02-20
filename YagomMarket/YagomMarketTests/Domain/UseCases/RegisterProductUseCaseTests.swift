//
//  RegisterProductUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

import XCTest
@testable import YagomMarket

final class RegisterProductUseCaseTests: XCTestCase {
    var sut: RegisterProductUseCase!
    var productRepositoryMock: ProductsRepositoryMock!
    
    override func setUpWithError() throws {
        productRepositoryMock = ProductsRepositoryMock()
        sut = DefaultRegisterProductUseCase(
            productsRepository: productRepositoryMock
        )
    }
    override func tearDownWithError() throws {
        productRepositoryMock = nil
        sut = nil
    }
    
    func test_실행했을때_productRepository의_requestPost메서드가실행되는지() async throws {
        // given
        let expectationCallCount = 1
        
        // when
        try await sut.execute(with: RegisterModel.stub())
        
        // then
        XCTAssertEqual(expectationCallCount, productRepositoryMock.requestPostCallCount)
    }
}

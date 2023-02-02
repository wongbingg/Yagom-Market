//
//  FetchProductDetailUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
@testable import YagomMarket

final class FetchProductDetailUseCaseTests: XCTestCase {

    class ProductRepositoryMock: ProductsRepository {
        
        var fetchProductDetailMethodCallCount = 0
        var passedProductId = 0
        
        func fetchProductsList(pageNumber: Int,
                               itemPerPage: Int,
                               searchValue: String?) async throws -> ProductListResponseDTO {
            return ProductListResponseDTO.toMockData(hasNext: false)
        }
        
        func fetchProductDetail(productId: Int) async throws -> ProductDetail {
            fetchProductDetailMethodCallCount += 1
            passedProductId = productId
            if productId > 100 {
                throw ProductsRepositoryError.noSuchProductId
            } else {
                return ProductDetail.toMockData()
            }
        }
        
        func fetchProductsQuery(keyword: String) async throws -> [String] {
            return []
        }
        
        func editProductDetail(with editModel: ProductEditRequestDTO,
                               productId: Int) async throws {}
        
        func deleteProduct(productId: Int) async throws {}
    }
    
    func test_UseCase실행될때_ProductRepository의_fetchProductDetail메서드가실행되는지() async throws {
        // given
        let expectationCallCount = 1
        let expectationProductId = 10
        let expectationResponse = ProductDetail.toMockData()
        let productRepository = ProductRepositoryMock()
        let useCase = FetchProductDetailUseCase(productsRepository: productRepository)
        
        // when
        let response = try await useCase.execute(productId: expectationProductId)
        
        // then
        XCTAssertEqual(expectationCallCount, productRepository.fetchProductDetailMethodCallCount)
        XCTAssertEqual(expectationProductId, productRepository.passedProductId)
        XCTAssertEqual(expectationResponse, response)
    }
    
    func test_UseCase실행될때_productId에해당상품이존재하지않을때_noSuchProduct에러를반환하는지() async throws {
        // given
        let expextationError = ProductsRepositoryError.noSuchProductId
        let productId = 101
        let productRepository = ProductRepositoryMock()
        let useCase = FetchProductDetailUseCase(productsRepository: productRepository)
        
        // when
        do {
            let response = try await useCase.execute(productId: productId)
        } catch let error as ProductsRepositoryError {
            // then
            XCTAssertEqual(expextationError, error)
        }
    }
}

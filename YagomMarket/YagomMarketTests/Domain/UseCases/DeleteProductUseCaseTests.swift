//
//  DeleteProductUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
@testable import YagomMarket

final class DeleteProductUseCaseTests: XCTestCase {

    class ProductRepositoryMock: ProductsRepository {
        var deleteMethodCallCount = 0
        var passedProductId = 0
        
        func fetchProductsList(pageNumber: Int,
                               itemPerPage: Int,
                               searchValue: String?) async throws -> ProductListResponseDTO {
            return ProductListResponseDTO.toMockData(hasNext: false)
        }
        
        func fetchProductDetail(productId: Int) async throws -> ProductDetail {
            return ProductDetail.toMockData()
        }
        
        func fetchProductsQuery(keyword: String) async throws -> [String] {
            return []
        }
        
        func editProductDetail(with editModel: ProductEditRequestDTO,
                               productId: Int) async throws {}
        
        func deleteProduct(productId: Int) async throws {
            deleteMethodCallCount += 1
            passedProductId = productId
        }
    }
    
    func test_UseCase실행될때_ProductRepository의deleteProduct메서드가실행되는지() async throws {
        // given
        let expectationCallCount = 1
        let expectationProductId = 10
        let productRepository = ProductRepositoryMock()
        let useCase = DeleteProductUseCase(productsRepository: productRepository)
        
        // when
        try await useCase.execute(productId: expectationProductId)
        
        // then
        XCTAssertEqual(expectationCallCount, productRepository.deleteMethodCallCount)
        XCTAssertEqual(expectationProductId, productRepository.passedProductId)
    }
}

//
//  SearchQueryResultsUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
@testable import YagomMarket

final class SearchQueryResultsUseCaseTests: XCTestCase {

    class ProductsRepositoryMock: ProductsRepository {
        var fetchProductsListCallCount = 0
        
        func fetchProductsList(pageNumber: Int,
                               itemPerPage: Int,
                               searchValue: String?) async throws -> YagomMarket.ProductListResponseDTO {
            
            fetchProductsListCallCount += 1
            
            return ProductListResponseDTO.toMockData(hasNext: true)
        }
        
        func fetchProductDetail(productId: Int) async throws -> YagomMarket.ProductDetail {
            ProductDetail.toMockData()
        }
        
        func fetchProductsQuery(keyword: String) async throws -> [String] {
            return []
        }
        
        func editProductDetail(with editModel: YagomMarket.ProductEditRequestDTO,
                               productId: Int) async throws {}
        
        func deleteProduct(productId: Int) async throws {}
    }
    
    func test_UseCase를실행할때_ProductRepository의_fetchProductList메서드가실행되는지() async throws {
        // given
        let expectationCallCount = 1
        let productsRepository = ProductsRepositoryMock()
        let useCase = SearchQueryResultsUseCase(productsRepository: productsRepository)
        
        // when
        _ = try await useCase.execute(keyword: "valid keyword")
        
        // then
        XCTAssertEqual(expectationCallCount, productsRepository.fetchProductsListCallCount)
    }
}

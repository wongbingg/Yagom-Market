//
//  SearchQueryUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
@testable import YagomMarket

final class SearchQueryUseCaseTests: XCTestCase {
    
    class ProductsRepositoryMock: ProductsRepository {
        var fetchProductsQueryCallCount = 0
        
        func fetchProductsList(pageNumber: Int, itemPerPage: Int, searchValue: String?) async throws -> YagomMarket.ProductListResponseDTO {
            return ProductListResponseDTO.toMockData(hasNext: true)
        }
        
        func fetchProductDetail(productId: Int) async throws -> YagomMarket.ProductDetail {
            ProductDetail.toMockData()
        }
        
        func fetchProductsQuery(keyword: String) async throws -> [String] {
            fetchProductsQueryCallCount += 1
            if keyword == "invalid keyword" {
                throw ProductsRepositoryError.noSuchKeyword
            }
            return []
        }
        
        func editProductDetail(with editModel: YagomMarket.ProductEditRequestDTO,
                               productId: Int) async throws {}
        
        func deleteProduct(productId: Int) async throws {}
    }
    
    func test_UseCase실행시_ProductsRepository의fetchProductsQuery를실행하는지() async throws {
        // given
        let expectationCallCount = 1
        let productsRepository = ProductsRepositoryMock()
        let useCase = SearchQueryUseCase(productsRepository: productsRepository)
        
        // when
        
        _ = try await useCase.execute(keyword: "keyword")
        
        // then
        XCTAssertEqual(expectationCallCount, productsRepository.fetchProductsQueryCallCount)
    }
    
    func test_UseCase실행시_해당keyword의검색결과가없는경우_noSuchKeyword오류를반환하는지() async throws {
        // given
        let expectationError = ProductsRepositoryError.noSuchKeyword
        let productsRepository = ProductsRepositoryMock()
        let useCase = SearchQueryUseCase(productsRepository: productsRepository)
        
        // when
        do {
            _ = try await useCase.execute(keyword: "invalid keyword")
        } catch let error as ProductsRepositoryError {
            // then
            XCTAssertEqual(expectationError, error)
        }
    }
}

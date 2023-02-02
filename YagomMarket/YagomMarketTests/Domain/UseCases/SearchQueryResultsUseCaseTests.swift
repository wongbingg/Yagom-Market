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
            
            if searchValue == "invalid keyword" {
                throw ProductsRepositoryError.noSuchKeyword
            } else {
                return ProductListResponseDTO.toMockData(hasNext: true)
            }
        }
        
        func fetchProductDetail(productId: Int) async throws -> YagomMarket.ProductDetail {
            ProductDetail.toMockData()
        }
        
        func fetchProductsQuery(keyword: String) async throws -> [String] {
            
            if keyword == "invalid keyword" {
                throw ProductsRepositoryError.noSuchKeyword
            }
            return []
        }
        
        func editProductDetail(with editModel: YagomMarket.ProductEditRequestDTO,
                               productId: Int) async throws {}
        
        func deleteProduct(productId: Int) async throws {}
    }
    
    func test_UseCase를실행할때_ProductRepository의fetchProductList메서드가실행된다() async throws {
        // given
        let expectationCallCount = 1
        let productsRepository = ProductsRepositoryMock()
        let useCase = SearchQueryResultsUseCase(productsRepository: productsRepository)
        
        // when
        _ = try await useCase.execute(keyword: "valid keyword")
        
        // then
        XCTAssertEqual(expectationCallCount, productsRepository.fetchProductsListCallCount)
    }
    
    func test_UseCase를실행할때_keyword가유효하지않으면_noSuchKeyword에러를반환한다() async throws {
        // given
        let expectationError = ProductsRepositoryError.noSuchKeyword
        let productsRepository = ProductsRepositoryMock()
        let useCase = SearchQueryResultsUseCase(productsRepository: productsRepository)
        
        // when
        do {
            _ = try await useCase.execute(keyword: "invalid keyword")
        } catch let error as ProductsRepositoryError {
            // then
            XCTAssertEqual(expectationError, error)
        }
    }
}

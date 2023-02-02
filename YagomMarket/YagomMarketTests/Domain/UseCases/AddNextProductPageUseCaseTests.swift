//
//  AddNextProductPageUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import XCTest
@testable import YagomMarket

final class AddNextProductPageUseCaseTests: XCTestCase {
    
    class ProductRepositoryMock: ProductsRepository {
        var hasNext: Bool = true
        
        func fetchProductsList(pageNumber: Int,
                               itemPerPage: Int,
                               searchValue: String?) async throws -> ProductListResponseDTO {
            return ProductListResponseDTO.toMockData(hasNext: hasNext)
        }
        
        func fetchProductDetail(productId: Int) async throws -> ProductDetail {
            return ProductDetail.toMockData()
        }
        
        func fetchProductsQuery(keyword: String) async throws -> [String] {
            return []
        }
        
        func editProductDetail(with editModel: ProductEditRequestDTO,
                               productId: Int) async throws {}
        
        func deleteProduct(productId: Int) async throws {}
    }
    
    func test_hasNext가true일때_값을성공적으로받아오는지() async throws {
        // given
        var response: [ProductCell]?
        let productRepository = ProductRepositoryMock()
        let useCase = DefaultAddNextProductPageUseCase(productsRepository: productRepository)
        
        // when
        response = try await useCase.execute()
        
        // then
        XCTAssertNotNil(response)
    }
    
    func test_hasNext가false일때_noHasNext오류를반환하는지() async throws {
        // given
        let expectationError = ProductsRepositoryError.noNextPage
        let productRepository = ProductRepositoryMock()
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

//
//  ProductsRepositoryMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import Foundation
@testable import YagomMarket

class ProductsRepositoryMock: ProductsRepository {
    
    var fetchProductDetailMethodCallCount = 0
    var fetchProductsListCallCount = 0
    var fetchProductsQueryCallCount = 0
    var deleteMethodCallCount = 0
    var requestPostCallCount = 0
    var editProductDetailCallCount = 0
    var passedProductId = 0
    var hasNext: Bool = true
    
    func fetchProductsList(pageNumber: Int,
                           itemPerPage: Int,
                           searchValue: String?) async throws -> ProductListResponseDTO {
        
        fetchProductsListCallCount += 1
        
        return ProductListResponseDTO.toMockData(hasNext: hasNext)
    }
    
    func fetchProductDetail(productId: Int) async throws -> ProductDetail {
        fetchProductDetailMethodCallCount += 1
        passedProductId = productId
        return ProductDetail.stub()
    }
    
    func fetchProductsQuery(keyword: String) async throws -> [String] {
        fetchProductsQueryCallCount += 1
        
        return []
    }
    
    func requestPost(with registerModel: RegisterModel) async throws {
        requestPostCallCount += 1
    }
    
    func editProductDetail(with editModel: ProductEditRequestDTO,
                           productId: Int) async throws {
        editProductDetailCallCount += 1
        passedProductId = productId
    }
    
    func deleteProduct(productId: Int) async throws {
        deleteMethodCallCount += 1
        passedProductId = productId
    }
}

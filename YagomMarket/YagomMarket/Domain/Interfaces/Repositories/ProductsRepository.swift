//
//  ProductsRepository.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/23.
//

import Foundation

protocol ProductsRepository {
    func fetchProductsList(pageNumber: Int,
                           itemPerPage: Int,
                           searchValue: String?) async throws -> ProductListResponseDTO
    
    func fetchProductDetail(productId: Int) async throws -> ProductDetail
    
    func fetchProductsQuery(keyword: String) async throws -> [String]
    
    func requestPost(with registerModel: RegisterModel) async throws
    
    func editProductDetail(with editModel: ProductEditRequestDTO,
                           productId: Int) async throws
    
    func deleteProduct(productId: Int) async throws
}

enum ProductsRepositoryError: LocalizedError {
    case noNextPage
    
    var errorDescription: String? {
        switch self {
        case .noNextPage:
            return "ProductRepository의 마지막 페이지 입니다."
        }
    }
}

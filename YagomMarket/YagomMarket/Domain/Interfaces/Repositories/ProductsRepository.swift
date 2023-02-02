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
    
    func editProductDetail(with editModel: ProductEditRequestDTO,
                           productId: Int) async throws
    
    func deleteProduct(productId: Int) async throws
}

enum ProductsRepositoryError: LocalizedError {
    case noNextPage
    case noSuchProductId
    case noSuchKeyword
    case failToFetch
    case failToEdit
    case failToDelete
    
    var errorDescription: String? {
        switch self {
        case .noNextPage:
            return "ProductRepository의 마지막 페이지 입니다."
        case .noSuchProductId:
            return "ProductRepository에 해당 Id의 상품이 없습니다."
        case .noSuchKeyword:
            return "ProductRepository에 해당 keyword의 검색결과가 없습니다."
        case .failToFetch:
            return "ProductRepository에서 fetch를 실패했습니다."
        case .failToEdit:
            return "ProductRepository에 있는 데이터를 수정하는데 실패했습니다."
        case .failToDelete:
            return "ProductRepository에 있는 데이터를 삭제하는데 실패했습니다."
        }
    }
}

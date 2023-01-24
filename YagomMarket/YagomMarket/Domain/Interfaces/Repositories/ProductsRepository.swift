//
//  ProductsRepository.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/23.
//

import Foundation

protocol ProductsRepository {
    func fetchProductsList(pageNumber: Int,
                           itemPerPage: Int) async throws -> ProductListResponseDTO
    func fetchProductDetail(productId: Int) async throws -> ProductDetail
    func editProductDetail(with editModel: ProductEditRequestDTO,
                           productId: Int) async throws
    func deleteProduct(productId: Int) async throws
}

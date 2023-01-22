//
//  ProductDetailRepository.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/20.
//

import Foundation

protocol ProductDetailRepository {
    func fetchProductDetail(productId: Int) async throws -> ProductDetail
    func editProductDetail(with editModel: ProductEditRequestDTO,
                           productId: Int) async throws
    func deleteProduct(productId: Int) async throws
}


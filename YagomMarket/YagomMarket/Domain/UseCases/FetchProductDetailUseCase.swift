//
//  FetchProductDetailUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/23.
//

import Foundation

final class FetchProductDetailUseCase {
    private let productsRepository: ProductsRepository
    
    init(productsRepository: ProductsRepository) {
        self.productsRepository = productsRepository
    }
    
    func execute(productId: Int) async throws -> ProductDetail {
        let response = try await productsRepository.fetchProductDetail(productId: productId)
        return response
    }
}

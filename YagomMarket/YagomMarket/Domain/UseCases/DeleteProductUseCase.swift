//
//  DeleteProductUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/23.
//

final class DeleteProductUseCase {
    private let productsRepository: ProductsRepository
    
    init(productsRepository: ProductsRepository) {
        self.productsRepository = productsRepository
    }
    
    func execute(productId: Int) async throws {
        try await productsRepository.deleteProduct(productId: productId)
    }
}

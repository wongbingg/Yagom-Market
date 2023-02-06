//
//  DeleteProductUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/23.
//

protocol DeleteProductUseCase {
    func execute(productId: Int) async throws
}

final class DefaultDeleteProductUseCase: DeleteProductUseCase {
    private let productsRepository: ProductsRepository
    
    init(productsRepository: ProductsRepository) {
        self.productsRepository = productsRepository
    }
    
    func execute(productId: Int) async throws {
        try await productsRepository.deleteProduct(productId: productId)
    }
}

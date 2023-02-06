//
//  EditProductUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/06.
//

protocol EditProductUseCase {
    func execute(with requestDTO: ProductEditRequestDTO,
                 productId: Int) async throws
}

final class DefaultEditProductUseCase: EditProductUseCase {
    private let productsRepository: ProductsRepository
    
    init(productsRepository: ProductsRepository) {
        self.productsRepository = productsRepository
    }
    
    func execute(with requestDTO: ProductEditRequestDTO,
                 productId: Int) async throws {
        
        try await productsRepository.editProductDetail(
            with: requestDTO,
            productId: productId
        )
    }
}

//
//  RegisterProductUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/06.
//

protocol RegisterProductUseCase {
    func execute(with registerModel: RegisterModel) async throws
}

final class DefaultRegisterProductUseCase: RegisterProductUseCase {
    private let productsRepository: ProductsRepository
    
    init(productsRepository: ProductsRepository) {
        self.productsRepository = productsRepository
    }
    
    func execute(with registerModel: RegisterModel) async throws {
        try await productsRepository.requestPost(with: registerModel)
    }
}

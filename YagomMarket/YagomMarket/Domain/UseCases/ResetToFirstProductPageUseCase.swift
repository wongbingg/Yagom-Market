//
//  ResetToFirstProductPageUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/23.
//

import Foundation

final class ResetToFirstProductPageUseCase {
    let productsRepository: ProductsRepository
    
    init(productsRepository: ProductsRepository) {
        self.productsRepository = productsRepository
    }
    
    func execute() async throws -> [ProductCell] {
        AddNextProductPageUseCase.currentPage = 1
        let response = try await productsRepository.fetchProductsList(
            pageNumber: AddNextProductPageUseCase.currentPage,
            itemPerPage: AddNextProductPageUseCase.currentItemPerPage,
            searchValue: nil
        )
        AddNextProductPageUseCase.hasNext = response.hasNext
        return response.toDomain()
    }
}

//
//  SearchQueryUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/26.
//

final class SearchQueryUseCase {
    private let productsRepository: ProductsRepository
    
    init(productsRepository: ProductsRepository) {
        self.productsRepository = productsRepository
    }
    
    func execute(keyword: String) async throws -> [String] {
        let response = try await productsRepository.fetchProductsQuery(keyword: keyword)
        return response
    }
}

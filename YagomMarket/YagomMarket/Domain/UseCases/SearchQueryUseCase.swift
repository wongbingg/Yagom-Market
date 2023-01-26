//
//  SearchQueryUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/26.
//

final class SearchQueryUseCase {
    private let productsQueryRepository: ProductsQueryRepository
    
    init(productsQueryRepository: ProductsQueryRepository) {
        self.productsQueryRepository = productsQueryRepository
    }
    
    func execute(keyword: String) async throws -> [String] {
        let response = try await productsQueryRepository.fetchProductsQuery(keyword: keyword)
        return response
    }
}

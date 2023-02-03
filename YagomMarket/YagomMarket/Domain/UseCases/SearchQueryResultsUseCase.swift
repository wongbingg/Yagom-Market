//
//  SearchQueryResultsUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/26.
//

protocol SearchQueryResultsUseCase {
    func execute(keyword: String) async throws -> ProductListResponseDTO
}

final class DefaultSearchQueryResultsUseCase: SearchQueryResultsUseCase {
    private let productsRepository: ProductsRepository
    
    init(productsRepository: ProductsRepository) {
        self.productsRepository = productsRepository
    }
    
    func execute(keyword: String) async throws -> ProductListResponseDTO {
        return try await productsRepository.fetchProductsList(
            pageNumber: 1,
            itemPerPage: 100,
            searchValue: keyword.lowercased()
        )
    }
}

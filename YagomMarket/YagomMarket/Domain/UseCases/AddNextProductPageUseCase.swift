//
//  AddNextProductPageUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/23.
//

final class AddNextProductPageUseCase {
    static var hasNext: Bool?
    static var currentPage = 1
    static let currentItemPerPage = 50
    
    private var productsRepository: ProductsRepository
    
    init(productsRepository: ProductsRepository) {
        self.productsRepository = productsRepository
    }
    
    func execute() async throws -> [ProductCell] {
        guard let hasNext = Self.hasNext, hasNext == true else { return [] }
        Self.currentPage += 1
        let response = try await productsRepository.fetchProductsList(
            pageNumber: Self.currentPage,
            itemPerPage: Self.currentItemPerPage,
            searchValue: nil
        )
        Self.hasNext = response.hasNext
        return response.toDomain()
    }
}

//
//  AddNextProductPageUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/23.
//

protocol AddNextProductPageUseCase {
    func execute() async throws -> [ProductCell]
    func resetToFirstPage()
}

final class DefaultAddNextProductPageUseCase: AddNextProductPageUseCase {
    private var hasNext: Bool = true
    private var currentPage = 1
    private let currentItemPerPage = 50
    
    private var productsRepository: ProductsRepository
    
    init(productsRepository: ProductsRepository) {
        self.productsRepository = productsRepository
    }
    
    func execute() async throws -> [ProductCell] {
        guard hasNext == true else { throw ProductsRepositoryError.noNextPage }
        currentPage += 1
        let response = try await productsRepository.fetchProductsList(
            pageNumber: currentPage,
            itemPerPage: currentItemPerPage,
            searchValue: nil
        )
        self.hasNext = response.hasNext
        return response.toDomain()
    }
    
    func resetToFirstPage() {
        currentPage = 1
    }
}

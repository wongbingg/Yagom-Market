//
//  DefaultProductsListRepository.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/22.
//

import Foundation

final class DefaultProductsListRepository {
    
}

extension DefaultProductsListRepository: ProductsListRepository {
    func fetchProductsList(pageNumber: Int,
                           itemPerPage: Int) async throws -> [ProductCell] {
        let api = SearchProductListAPI(pageNumber: pageNumber, itemPerPage: itemPerPage)
        let response = try await api.execute()
        return response.toDomain()
    }
}

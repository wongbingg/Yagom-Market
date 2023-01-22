//
//  DefaultProductsQueryRepository.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/22.
//

import Foundation

final class DefaultProductsQueryRepository {
    
}

extension DefaultProductsQueryRepository: ProductQueryRepositories {
    
    func fetchProductsQuery(keyword: String) async throws -> [String] {
        var list = [String]()
        let api = SearchProductListAPI(
            pageNumber: 1,
            itemPerPage: 100,
            searchValue: keyword
        )
        let response = try await api.execute()
        response.pages.forEach { page in
            list.append(page.name)
        }
        return Array(Set(list))
    }
}

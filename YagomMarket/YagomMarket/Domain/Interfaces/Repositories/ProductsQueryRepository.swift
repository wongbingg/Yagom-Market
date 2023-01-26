//
//  ProductsQueryRepository.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/22.
//

import Foundation

protocol ProductsQueryRepository {
    func fetchProductsQuery(keyword: String) async throws -> [String]
    
}

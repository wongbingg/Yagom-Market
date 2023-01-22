//
//  ProductsRepository.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/20.
//

import Foundation

protocol ProductsListRepository {
    func fetchProductsList(pageNumber: Int,
                           itemPerPage: Int) async throws -> [ProductCell]
}

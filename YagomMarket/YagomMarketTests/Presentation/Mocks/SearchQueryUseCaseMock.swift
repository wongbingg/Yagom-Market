//
//  SearchQueryUseCaseMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

@testable import YagomMarket

final class SearchQueryUseCaseMock: SearchQueryUseCase {
    
    func execute(keyword: String) async throws -> [String] {
        
        if keyword == "invalid" {
            throw APIError.unknown
        } else {
            return []
        }
    }
}

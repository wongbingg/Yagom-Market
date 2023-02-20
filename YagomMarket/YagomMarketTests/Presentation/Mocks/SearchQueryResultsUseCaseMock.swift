//
//  SearchQueryResultsUseCaseMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

@testable import YagomMarket

final class SearchQueryResultsUseCaseMock: SearchQueryResultsUseCase {
    
    func execute(keyword: String) async throws -> ProductListResponseDTO {
        
        if keyword == "invalid" {
            throw APIError.unknown
        } else {
            return ProductListResponseDTO.toMockData(hasNext: true)
        }
    }
}

//
//  FetchProductDetailUseCaseMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

@testable import YagomMarket

final class FetchProductDetailUseCaseMock: FetchProductDetailUseCase {
    
    func execute(productId: Int) async throws -> ProductDetail {
        if productId == 1 {
            throw APIError.unknown
        }
        return ProductDetail.stub()
    }
}

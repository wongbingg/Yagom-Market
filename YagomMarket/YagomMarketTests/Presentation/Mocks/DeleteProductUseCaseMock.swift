//
//  DeleteProductUseCaseMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

@testable import YagomMarket

final class DeleteProductUseCaseMock: DeleteProductUseCase {
    var callCount = 0
    
    func execute(productId: Int) async throws {
        callCount += 1
    }
}

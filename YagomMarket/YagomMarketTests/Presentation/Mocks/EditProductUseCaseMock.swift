//
//  EditProductUseCaseMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

@testable import YagomMarket

final class EditProductUseCaseMock: EditProductUseCase {
    var callCount = 0
    
    func execute(with requestDTO: ProductEditRequestDTO,
                 productId: Int) async throws {
        callCount += 1
    }
}

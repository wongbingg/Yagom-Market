//
//  AddNextProductPageUseCaseMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

@testable import YagomMarket

class AddNextProductPageUseCaseMock: AddNextProductPageUseCase {
    var hasNext: Bool = true

    func execute() async throws -> [ProductCell] {
        guard hasNext == true  else { throw ProductsRepositoryError.noNextPage }
        
        return [ProductCell.stub()]
    }
    
    func resetToFirstPage() {
        hasNext = true
    }
}

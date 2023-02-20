//
//  RegisterProductUseCaseMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

@testable import YagomMarket

final class RegisterProductUseCaseMock: RegisterProductUseCase {
    var callCount = 0
    
    func execute(with registerModel: RegisterModel) async throws {
        callCount += 1
    }
}

//
//  LoginUseCaseMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

@testable import YagomMarket

final class LoginUseCaseMock: LoginUseCase {
    
    func execute(with loginInfo: LoginInfo) async throws -> String? {
        if loginInfo.vendorName == "invalid" {
            throw FirebaseAuthServiceError.failToLogin
        }
        return "userUID"
    }
}

//
//  LoginUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

import FirebaseAuth

protocol LoginUseCase {
    func execute(with loginInfo: LoginInfo) async throws -> String?
}

final class DefaultLoginUseCase: LoginUseCase {
    private let firebaseAuthService: FirebaseAuthService
    
    init(firebaseAuthService: FirebaseAuthService) {
        self.firebaseAuthService = firebaseAuthService
    }
    
    func execute(with loginInfo: LoginInfo) async throws -> String? {
        let response = try await firebaseAuthService.logIn(
            email: loginInfo.id,
            password: loginInfo.password
        )
        return response?.user.uid
    }
}

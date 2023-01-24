//
//  SigninUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

import FirebaseAuth

final class SigninUseCase {
    private let firebaseAuthService: FirebaseAuthService
    
    init(firebaseAuthService: FirebaseAuthService) {
        self.firebaseAuthService = firebaseAuthService
    }
    
    func execute(with loginInfo: LoginInfo) async throws -> AuthDataResult? {
        let response = try await firebaseAuthService.signIn(
            email: loginInfo.id,
            password: loginInfo.password
        )
        return response
    }
}

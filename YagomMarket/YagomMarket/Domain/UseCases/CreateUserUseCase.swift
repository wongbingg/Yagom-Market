//
//  CreateUserUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

final class CreateUserUseCase {
    private let firebaseAuthService: FirebaseAuthService
    
    init(firebaseAuthService: FirebaseAuthService) {
        self.firebaseAuthService = firebaseAuthService
    }
    
    func execute(with loginInfo: LoginInfo) async throws {
        _ = try await firebaseAuthService.createUser(
            email: loginInfo.id,
            password: loginInfo.password
        )
    }
}

//
//  CreateUserUseCaseMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

@testable import YagomMarket

final class CreateUserUseCaseMock: CreateUserUseCase {
    let firebaseAuthService: FirebaseAuthService
    let firestoreService: any FirestoreService
    
    init(
        firebaseAuthService: FirebaseAuthService,
        firestoreService: any FirestoreService
    ) {
        self.firebaseAuthService = firebaseAuthService
        self.firestoreService = firestoreService
    }
    
    func execute(with loginInfo: LoginInfo) async throws {
        if loginInfo.vendorName == "invalid" {
            throw FirebaseAuthServiceError.failToCreateUser
        }
    }
    
}

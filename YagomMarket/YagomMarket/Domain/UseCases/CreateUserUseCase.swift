//
//  CreateUserUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

protocol CreateUserUseCase {
    func execute(with loginInfo: LoginInfo) async throws
}

final class DefaultCreateUserUseCase: CreateUserUseCase {
    private let firebaseAuthService: FirebaseAuthService
    private let firestoreService: any FirestoreService
    
    init(
        firebaseAuthService: FirebaseAuthService,
        firestoreService: any FirestoreService
    ) {
        self.firebaseAuthService = firebaseAuthService
        self.firestoreService = firestoreService
    }
    
    func execute(with loginInfo: LoginInfo) async throws {
        let response = try await firebaseAuthService.createUser(
            email: loginInfo.id,
            password: loginInfo.password
        )
        
        let userUID = response?.user.uid ?? "empty userUID"
        
        let email = loginInfo.id
        let vendorName = loginInfo.vendorName ?? "empty vendorName"
        let userInfo = UserProfile(
            vendorName: vendorName,
            email: email,
            likedProductIds: []
        )
        
        try await firestoreService.create(
            collectionId: "UserProfile",
            documentId: userUID,
            entity: userInfo
        )
    }
}

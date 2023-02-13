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
        let userUID = try await firebaseAuthService.createUser(
            email: loginInfo.id,
            password: loginInfo.password
        )
        
        let email = loginInfo.id
        let vendorName = loginInfo.vendorName
        let userInfo = UserProfile(
            vendorName: vendorName,
            email: email,
            identifier: loginInfo.identifier,
            secret: loginInfo.secret,
            likedProductIds: [],
            chattingUUIDList: []
        )
        
        try await firestoreService.create(
            collectionId: "UserProfile",
            documentId: userUID,
            entity: userInfo
        )
    }
}

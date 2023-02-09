//
//  SearchUserProfileUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/31.
//

protocol SearchUserProfileUseCase {
    func execute(othersUID: String?) async throws -> UserProfile
}

final class DefaultSearchUserProfileUseCase: SearchUserProfileUseCase {
    private let firestoreService: any FirestoreService
    
    init(firestoreService: any FirestoreService) {
        self.firestoreService = firestoreService
    }
    
    func execute(othersUID: String?) async throws -> UserProfile {
        
        guard let userUID = LoginCacheManager.fetchPreviousInfo() else {
            throw LoginCacheManagerError.noPreviousInfo
        }
        let validUID = othersUID ?? userUID
        
        let response = try await firestoreService.read(
            collectionId: "UserProfile",
            documentId: validUID
        )
        
        return response as! UserProfile
        
    }
}

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
        
        if let othersUID = othersUID {
            let response = try await firestoreService.read(
                collectionId: "UserProfile",
                documentId: othersUID
            )
            
            return response as! UserProfile
        } else {
            guard let loginInfo = LoginCacheManager.fetchPreviousInfo() else {
                throw LoginCacheManagerError.noPreviousInfo
            }
            
            let response = try await firestoreService.read(
                collectionId: "UserProfile",
                documentId: loginInfo.userUID
            )
            
            return response as! UserProfile
        }
    }
}

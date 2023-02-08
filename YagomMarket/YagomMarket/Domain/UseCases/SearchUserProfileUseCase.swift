//
//  SearchUserProfileUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/31.
//

protocol SearchUserProfileUseCase {
    func execute(userUID: String?) async throws -> UserProfile
}

final class DefaultSearchUserProfileUseCase: SearchUserProfileUseCase {
    private let firestoreService: any FirestoreService
    
    init(firestoreService: any FirestoreService) {
        self.firestoreService = firestoreService
    }
    
    func execute(userUID: String? = nil) async throws -> UserProfile {
        if let userUID = userUID {
            let response = try await firestoreService.read(
                collectionId: "UserProfile",
                documentId: userUID
            )
            
            return response as! UserProfile
        } else {
            guard let userUID = LoginCacheManager.fetchPreviousInfo() else {
                throw LoginCacheManagerError.noPreviousInfo
            }
            let response = try await firestoreService.read(
                collectionId: "UserProfile",
                documentId: userUID
            )
            
            return response as! UserProfile
        }
    }
}

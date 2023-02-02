//
//  SearchUserProfileUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/31.
//

final class SearchUserProfileUseCase {
    private let firestoreService: DefaultFirestoreService<UserProfile>
    
    init(
        firestoreService: DefaultFirestoreService<UserProfile>
    ) {
        self.firestoreService = firestoreService
    }
    
    func execute() async throws -> UserProfile {
        guard let userUID = LoginCacheManager.fetchPreviousInfo() else {
            throw LoginCacheManagerError.noPreviousInfo
        }
        
        let response = try await firestoreService.read(
            collectionId: "UserProfile",
            documentId: userUID,
            entity: UserProfile()
        )
        
        return response
    }
}

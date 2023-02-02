//
//  HandleLikedProductUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/01.
//

final class HandleLikedProductUseCase {
    private let firestoreService: DefaultFirestoreService<UserProfile>
    
    init(
        firestoreService: DefaultFirestoreService<UserProfile>
    ) {
        self.firestoreService = firestoreService
    }
    
    func execute(with productId: Int, isAdd: Bool) async throws {
        guard let userUID = LoginCacheManager.fetchPreviousInfo() else {
            throw LoginCacheManagerError.noPreviousInfo
        }
        
        var userProfile = try await firestoreService.read(
            collectionId: "UserProfile",
            documentId: userUID,
            entity: UserProfile()
        )
        
        if isAdd {
            userProfile.likedProductIds.append(productId)
        } else {
            let index = userProfile.likedProductIds.firstIndex(of: productId)!
            userProfile.likedProductIds.remove(at: index)
        }
        
        try await firestoreService.update(
            collectionId: "UserProfile",
            documentId: userUID,
            to: userProfile
        )
    }
}

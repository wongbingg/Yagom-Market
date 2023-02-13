//
//  HandleLikedProductUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/01.
//

protocol HandleLikedProductUseCase {
    func execute(with productId: Int, isAdd: Bool) async throws
}

final class DefaultHandleLikedProductUseCase: HandleLikedProductUseCase {
    private let firestoreService: any FirestoreService
    
    init(
        firestoreService: any FirestoreService
    ) {
        self.firestoreService = firestoreService
    }
    
    func execute(with productId: Int, isAdd: Bool) async throws {
        guard let loginInfo = LoginCacheManager.fetchPreviousInfo() else {
            throw LoginCacheManagerError.noPreviousInfo
        }
        
        var userProfile = try await firestoreService.read(
            collectionId: "UserProfile",
            documentId: loginInfo.userUID
        ) as! UserProfile
        
        if isAdd {
            userProfile.likedProductIds.append(productId)
        } else {
            guard let index = userProfile.likedProductIds.firstIndex(of: productId) else {
                throw FirestoreServiceError.noSuchId(productId)
            }
            userProfile.likedProductIds.remove(at: index)
        }
        
        try await firestoreService.update(
            collectionId: "UserProfile",
            documentId: loginInfo.userUID,
            to: userProfile
        )
    }
}

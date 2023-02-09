//
//  HandleChattingUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/08.
//

import Foundation
protocol HandleChattingUseCase {
    func execute(chattingUUID: String,
                 isAdded: Bool,
                 othersUID: String?) async throws
}

final class DefaultHandleChattingUseCase: HandleChattingUseCase {
    private let firestoreService: any FirestoreService
    
    init(
        firestoreService: any FirestoreService
    ) {
        self.firestoreService = firestoreService
    }
    
    func execute(chattingUUID: String,
                 isAdded: Bool,
                 othersUID: String?) async throws {
        guard let userUID = LoginCacheManager.fetchPreviousInfo() else {
            throw LoginCacheManagerError.noPreviousInfo
        }
        
        let validUID = othersUID ?? userUID
        
        var userProfile = try await firestoreService.read(
            collectionId: "UserProfile",
            documentId: validUID
        ) as! UserProfile
        
        if isAdded {
            userProfile.chattingUUIDList.append(chattingUUID)
        } else {
            guard let index = userProfile.chattingUUIDList.firstIndex(of: chattingUUID) else {
                throw FirestoreServiceError.noSuchChattingUUID(chattingUUID)
            }
            userProfile.likedProductIds.remove(at: index)
        }
        
        try await firestoreService.update(
            collectionId: "UserProfile",
            documentId: validUID,
            to: userProfile
        )
    }
}

//
//  HandleChattingUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/08.
//

import Foundation
protocol HandleChattingUseCase {
    func execute(chattingUUID: String, isAdd: Bool) async throws
}

final class DefaultHandleChattingUseCase: HandleChattingUseCase {
    private let firestoreService: any FirestoreService
    
    init(
        firestoreService: any FirestoreService
    ) {
        self.firestoreService = firestoreService
    }
    
    func execute(chattingUUID: String, isAdd: Bool) async throws {
        guard let userUID = LoginCacheManager.fetchPreviousInfo() else {
            throw LoginCacheManagerError.noPreviousInfo
        }
        
        var userProfile = try await firestoreService.read(
            collectionId: "UserProfile",
            documentId: userUID
        ) as! UserProfile
        
        if isAdd {
            userProfile.chattingUUIDList.append(chattingUUID)
        } else {
            guard let index = userProfile.chattingUUIDList.firstIndex(of: chattingUUID) else {
                throw FirestoreServiceError.noSuchChattingUUID(chattingUUID)
            }
            userProfile.likedProductIds.remove(at: index)
        }
        
        try await firestoreService.update(
            collectionId: "UserProfile",
            documentId: userUID,
            to: userProfile
        )
    }
}

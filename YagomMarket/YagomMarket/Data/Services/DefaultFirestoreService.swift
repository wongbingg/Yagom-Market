//
//  DefaultFirestoreService.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

import FirebaseFirestore

final class DefaultFirestoreService: FirestoreService {
    typealias T = UserProfile
    
    private let dataBase = Firestore.firestore()
    private let collectionId: String
    private let documentId: String
    
    init(collectionId: String, documentId: String) {
        self.collectionId = collectionId
        self.documentId = documentId
    }
    
    func create(_ entity: UserProfile) async throws {
        let dictionary = entity.toDictionary()
        try await dataBase.collection(collectionId)
            .document(documentId).setData(dictionary)
    }
    
    func read() async throws -> UserProfile {
        let documentSnapshot = try await dataBase.collection(collectionId)
            .document(documentId).getDocument()
        return documentSnapshot.toUserProfile()!
        
    }
    
    func update(to entity: UserProfile) async throws {
        let dictionary = entity.toDictionary()
        try await dataBase.collection(collectionId)
            .document(documentId).setData(dictionary)
    }
    
    func delete() async throws {
        try await dataBase.collection(collectionId)
            .document(documentId).delete()
    }
}

extension DocumentSnapshot {
    func toUserProfile() -> UserProfile? {
        guard let name = self.get("name") as? String,
              let email = self.get("email") as? String,
              let likedProductIds = self.get("likedProductIds") as? [Int] else { return nil }
        return .init(name: name, email: email, likedProductIds: likedProductIds)
    }
}

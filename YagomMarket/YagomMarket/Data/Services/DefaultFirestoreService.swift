//
//  DefaultFirestoreService.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

import FirebaseFirestore

protocol Entity {
    func toDictionary() -> Dictionary<String, Any>
    func toEntity(with documentSnapshot: DocumentSnapshot) -> Self
}

final class DefaultFirestoreService<E: Entity>: FirestoreService {
    typealias T = E
    private let dataBase = Firestore.firestore()
    
    func create(collectionId: String,
                documentId: String,
                entity: E) async throws {
        let dictionary = entity.toDictionary()
        try await dataBase
            .collection(collectionId)
            .document(documentId)
            .setData(dictionary)
    }
    
    func read(collectionId: String,
              documentId: String,
              entity: E) async throws -> E {
        let documentSnapshot = try await dataBase
            .collection(collectionId)
            .document(documentId)
            .getDocument()
        return documentSnapshot.toEntity(entity)!
    }
    
    func update(collectionId: String,
                documentId: String,
                to entity: E) async throws {
        let dictionary = entity.toDictionary()
        try await dataBase
            .collection(collectionId)
            .document(documentId).setData(dictionary)
    }
    
    func delete(collectionId: String,
                documentId: String) async throws {
        try await dataBase
            .collection(collectionId)
            .document(documentId).delete()
    }
}

extension DocumentSnapshot {

    func toEntity<E: Entity>(_ e: E) -> E? {
        e.toEntity(with: self)
    }
}

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

    func create<T>(collectionId: String, documentId: String, entity: T) async throws where T : Entity {
        let dictionary = entity.toDictionary()
        try await dataBase
            .collection(collectionId)
            .document(documentId)
            .setData(dictionary)
    }
    
    func read<T>(collectionId: String, documentId: String, entity: T) async throws -> T where T : Entity {
        let documentSnapshot = try await dataBase
            .collection(collectionId)
            .document(documentId)
            .getDocument()
        return documentSnapshot.toEntity(entity)!
    }
    
    func update<T>(collectionId: String, documentId: String, to entity: T) async throws where T : Entity {
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

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
        do {
            try await dataBase
                .collection(collectionId)
                .document(documentId)
                .setData(dictionary)
        } catch {
            throw FirestoreServiceError.failToCreate
        }
    }
    
    func read<T>(collectionId: String, documentId: String, entity: T) async throws -> T where T : Entity {
        do {
            let documentSnapshot = try await dataBase
                .collection(collectionId)
                .document(documentId)
                .getDocument()
            return documentSnapshot.toEntity(entity)!
        } catch {
            throw FirestoreServiceError.failToRead
        }
    }
    
    func update<T>(collectionId: String, documentId: String, to entity: T) async throws where T : Entity {
        let dictionary = entity.toDictionary()
        do {
            try await dataBase
                .collection(collectionId)
                .document(documentId).setData(dictionary)
        } catch {
            throw FirestoreServiceError.failToUpdate
        }
    }
    
    func delete(collectionId: String,
                documentId: String) async throws {
        do {
            try await dataBase
                .collection(collectionId)
                .document(documentId).delete()
        } catch {
            throw FirestoreServiceError.failToDelete
        }
    }
}

extension DocumentSnapshot {

    func toEntity<E: Entity>(_ e: E) -> E? {
        e.toEntity(with: self)
    }
}

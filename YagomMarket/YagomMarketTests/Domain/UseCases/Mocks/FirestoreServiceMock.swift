//
//  FirestoreServiceMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import Foundation
import FirebaseFirestore
@testable import YagomMarket

struct DummyEntity: Entity {
    let name: String
    
    func toDictionary() -> Dictionary<String, Any> {
        return ["name": name]
    }
    
    func toEntity(with documentSnapshot: DocumentSnapshot) -> DummyEntity {
        return self
    }
}

class FirestoreServiceMock: FirestoreService {
    typealias T = DummyEntity
    var firestore: [Entity] = []
    var createCallCount = 0
    var readCallCount = 0
    var updateCallCount = 0
    
    func create<T>(collectionId: String,
                   documentId: String,
                   entity: T) async throws where T : YagomMarket.Entity {
        firestore.append(entity)
        createCallCount += 1
    }

    func read<T>(collectionId: String,
                 documentId: String,
                 entity: T) async throws -> T where T : YagomMarket.Entity {

        readCallCount += 1

        return DummyEntity(name: "") as! T
    }

    func update<T>(collectionId: String,
                   documentId: String, to entity: T) async throws where T : YagomMarket.Entity {
        updateCallCount += 1
    }

    func delete(collectionId: String,
                documentId: String) async throws {}
}

class UserProfileFirestoreServiceMock: FirestoreService {
    typealias T = UserProfile
    var firestore: [Entity] = []
    var createCallCount = 0
    var readCallCount = 0
    var updateCallCount = 0
    
    func create<T>(collectionId: String,
                   documentId: String,
                   entity: T) async throws where T : YagomMarket.Entity {
        firestore.append(entity)
        createCallCount += 1
    }

    func read<T>(collectionId: String,
                 documentId: String,
                 entity: T) async throws -> T where T : YagomMarket.Entity {

        readCallCount += 1

        return UserProfile() as! T
    }

    func update<T>(collectionId: String,
                   documentId: String, to entity: T) async throws where T : YagomMarket.Entity {
        updateCallCount += 1
    }

    func delete(collectionId: String,
                documentId: String) async throws {}
}

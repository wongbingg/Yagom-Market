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
    
    static func toEntity(with documentSnapshot: DocumentSnapshot) -> DummyEntity {
        return DummyEntity(name: "")
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

    func read(collectionId: String,
                 documentId: String) async throws -> T {

        readCallCount += 1

        return DummyEntity(name: "")
    }
    
    func readDocuments(collectionId: String) async throws -> [DummyEntity] {
        return [DummyEntity(name: "")]
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

    func read(collectionId: String,
                 documentId: String) async throws -> T {

        readCallCount += 1

        return UserProfile.stub()
    }
    
    func readDocuments(collectionId: String) async throws -> [T] {
        return [UserProfile.stub()]
    }

    func update<T>(collectionId: String,
                   documentId: String, to entity: T) async throws where T : YagomMarket.Entity {
        updateCallCount += 1
    }

    func delete(collectionId: String,
                documentId: String) async throws {}
}

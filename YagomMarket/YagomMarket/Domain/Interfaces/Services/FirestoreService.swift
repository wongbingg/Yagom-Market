//
//  FirestoreService.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

import FirebaseCore
import FirebaseFirestore

protocol FirestoreService {
    associatedtype T

    func create<T: Entity>(collectionId: String, documentId: String, entity: T) async throws
    func read<T: Entity>(collectionId: String, documentId: String, entity: T) async throws -> T
    func update<T: Entity>(collectionId: String, documentId: String, to entity: T) async throws
    func delete(collectionId: String, documentId: String) async throws
}

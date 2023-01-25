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
    
    func create(_ entity: T) async throws
    func read() async throws -> T
    func update(to entity: T) async throws
    func delete() async throws
}


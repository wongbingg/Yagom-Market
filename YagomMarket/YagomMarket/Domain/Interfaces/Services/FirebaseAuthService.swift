//
//  FirebaseAuthService.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

import FirebaseAuth

protocol FirebaseAuthService {
    func createUser(email: String, password: String) async throws -> AuthDataResult?
    func signIn(email: String, password: String) async throws -> AuthDataResult?
}



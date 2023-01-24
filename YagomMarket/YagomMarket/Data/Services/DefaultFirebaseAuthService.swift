//
//  DefaultFirebaseAuthService.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

import FirebaseAuth

final class DefaultFirebaseAuthService: FirebaseAuthService {
    
    func createUser(email: String, password: String) async throws -> AuthDataResult? {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return authDataResult
        } catch {
            throw error
        }
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResult? {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return authDataResult
        } catch {
            throw LoginError.invalidUser
        }
    }
}

enum FirebaseAuthServiceError: Error {
    case createUserError
    case signInError
}

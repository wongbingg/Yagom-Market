//
//  DefaultFirebaseAuthService.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

import FirebaseAuth

final class DefaultFirebaseAuthService: FirebaseAuthService {
    
    func createUser(email: String,
                    password: String) async throws -> AuthDataResult? {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return authDataResult
        } catch {
            throw FirebaseAuthServiceError.createUserError
        }
    }
    
    func signIn(email: String,
                password: String) async throws -> AuthDataResult? {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return authDataResult
        } catch {
            throw FirebaseAuthServiceError.signInError
        }
    }
}

//
//  DefaultFirebaseAuthService.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

import FirebaseAuth

final class DefaultFirebaseAuthService: FirebaseAuthService {
    
    func createUser(email: String,
                    password: String) async throws -> String {
        do {
            let authDataResult = try await Auth.auth().createUser(
                withEmail: email,
                password: password
            )
            return authDataResult.user.uid
        } catch {
            throw FirebaseAuthServiceError.failToCreateUser
        }
    }
    
    func logIn(email: String,
                password: String) async throws -> String {
        do {
            let authDataResult = try await Auth.auth().signIn(
                withEmail: email,
                password: password
            )
            return authDataResult.user.uid
        } catch {
            throw FirebaseAuthServiceError.failToLogin
        }
    }
    
    func fetchUserUID() throws -> String {
        if let userUID = Auth.auth().currentUser?.uid {
            return userUID
        } else {
            throw FirebaseAuthServiceError.failToFetch
        }
    }
}

//
//  FirebaseAuthServiceMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/02.
//

import FirebaseAuth
@testable import YagomMarket

class FirebaseAuthServiceMock: FirebaseAuthService {
    var createUserCallCount = 0
    var signInCallCount = 0
    
    func createUser(email: String, password: String) async throws -> AuthDataResult? {
        createUserCallCount += 1
        return nil
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResult? {
        signInCallCount += 1
        
        return nil
    }
}

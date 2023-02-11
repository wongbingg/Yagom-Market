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
    var fetchUserUIDCallCount = 0
    
    func createUser(email: String, password: String) async throws -> String {
        createUserCallCount += 1
        return "userUID"
    }
    
    func logIn(email: String, password: String) async throws -> String {
        signInCallCount += 1
        return "userUID"
    }
    
    func fetchUserUID() throws -> String {
        fetchUserUIDCallCount += 1
        return "userUID"
    }
}

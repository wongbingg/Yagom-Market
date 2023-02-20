//
//  RecordVendorNameUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore
@testable import YagomMarket

final class RecordVendorNameUseCaseTests: XCTestCase {
    var sut: RecordVendorNameUseCase!
    var firestoreServiceMock: UserUIDFirestoreServiceMock!
    var firebaseAuthServiceMock: FirebaseAuthServiceMock!
    
    override func setUpWithError() throws {
        firestoreServiceMock = UserUIDFirestoreServiceMock()
        firebaseAuthServiceMock = FirebaseAuthServiceMock()
        
        sut = DefaultRecordVendorNameUseCase(
            firebaseAuthService: firebaseAuthServiceMock,
            firestoreService: firestoreServiceMock
        )
        
    }
    
    override func tearDownWithError() throws {
        firestoreServiceMock = nil
        firebaseAuthServiceMock = nil
        sut = nil
    }
    
    func test_UseCase실행시_FirestoreService의_create메서드가실행되는지() async throws {
        // given
        let expectationCreateCallCount = 1
        
        // when
        _ = try await sut.execute(with: "")
        
        // then
        XCTAssertEqual(expectationCreateCallCount, firestoreServiceMock.createCallCount)
    }
}

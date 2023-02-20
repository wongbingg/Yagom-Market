//
//  SearchOthersUIDUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore
@testable import YagomMarket

final class SearchOthersUIDUseCaseTests: XCTestCase {
    var sut: SearchOthersUIDUseCase!
    var firestoreServiceMock: UserUIDFirestoreServiceMock!
    
    override func setUpWithError() throws {
        firestoreServiceMock = UserUIDFirestoreServiceMock()
        sut = DefaultSearchOthersUIDUseCase(
            firestoreService: firestoreServiceMock
        )
        
    }
    
    override func tearDownWithError() throws {
        firestoreServiceMock = nil
        sut = nil
    }
    
    func test_UseCase실행시_FirestoreService의_read메서드가실행되는지() async throws {
        // given
        let expectationReadCallCount = 1
        
        // when
        let othersUID = try await sut.execute(with: "vendorName")
        
        // then
        XCTAssertEqual(expectationReadCallCount, firestoreServiceMock.readCallCount)
    }
}

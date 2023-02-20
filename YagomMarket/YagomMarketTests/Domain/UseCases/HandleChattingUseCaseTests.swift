//
//  HandleChattingUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore
@testable import YagomMarket

final class HandleChattingUseCaseTests: XCTestCase {
    var sut: HandleChattingUseCase!
    var firestoreServiceMock: UserProfileFirestoreServiceMock!
    
    override func setUpWithError() throws {
        firestoreServiceMock = UserProfileFirestoreServiceMock()
        sut = DefaultHandleChattingUseCase(
            firestoreService: firestoreServiceMock
        )
        
    }
    
    override func tearDownWithError() throws {
        firestoreServiceMock = nil
        sut = nil
    }
    
    func test_채팅이추가될때_FirestoreService의_update메서드가실행되는지() async throws {
        // given
        let expectationUpdateCallCount = 1
        
        // when
        _ = try await sut.execute(chattingUUID: "chattingUUID", isAdded: true, othersUID: "")
        
        // then
        XCTAssertEqual(expectationUpdateCallCount, firestoreServiceMock.updateCallCount)
    }
    
    func test_채팅이삭제될때_FirestoreService의_update메서드가실행되는지() async throws {
        // given
        let expectationUpdateCallCount = 1
        
        // when
        _ = try await sut.execute(chattingUUID: "chattingUUID", isAdded: false, othersUID: "")
        
        // then
        XCTAssertEqual(expectationUpdateCallCount, firestoreServiceMock.updateCallCount)
    }
}

//
//  SearchChattingUseCaseTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore
@testable import YagomMarket

final class SearchChattingUseCaseTests: XCTestCase {
    var sut: SearchChattingUseCase!
    var firestoreServiceMock: MessageFirestoreServiceMock!
    
    override func setUpWithError() throws {
        firestoreServiceMock = MessageFirestoreServiceMock()
        sut = DefaultSearchChattingUseCase(
            firestoreService: firestoreServiceMock
        )
        
    }
    
    override func tearDownWithError() throws {
        firestoreServiceMock = nil
        sut = nil
    }
    
    func test_UseCase실행시_FirestoreService의_readDocuments메서드가실행되는지() async throws {
        // given
        let expectationReadCallCount = 1
        
        // when
        _ = try await sut.execute(with: "chattingUUID")
        
        // then
        XCTAssertEqual(expectationReadCallCount, firestoreServiceMock.readDocumentsCallCount)
    }
}

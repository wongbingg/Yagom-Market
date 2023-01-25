//
//  FirestoreServiceTest.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/01/24.
//

import XCTest
@testable import YagomMarket

final class FirestoreServiceTest: XCTestCase {
    var sut: DefaultFirestoreService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DefaultFirestoreService(collectionId: "UserProfile", documentId: "test")
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_새로운데이터_저장이가능한지() async throws {
        // given
        let userProfile = UserProfile(name: "leewonbeen", email: "abc@naver.com", likedProductIds: [12,23,144])
        // when
        try await sut.create(userProfile)
        // then
        
    }
    
    func test_기존의데이터_삭제가가능한지() async throws {
        // given
        // when
        try await sut.delete()
        // then
        
    }
    
    func test_기존의데이터_읽어올수있는지() async throws {
        // given
        var userProfile: UserProfile?
        // when
        userProfile = try await sut.read()
        // then
//        XCTAssertNotNil(userProfile)
        print(userProfile)
    }
    
    func test_기존의데이터_수정할수있는지() async throws {
        // given
        let editedUserProfile = UserProfile(name: "leewonbeen", email: "abc@naver.com", likedProductIds: [12,23,144, 190, 1123])
        // when
        try await sut.update(to: editedUserProfile)
        // then

    }
}

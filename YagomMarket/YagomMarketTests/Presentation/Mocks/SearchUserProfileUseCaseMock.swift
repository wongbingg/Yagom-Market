//
//  SearchUserProfileUseCaseMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

@testable import YagomMarket

final class SearchUserProfileUseCaseMock: SearchUserProfileUseCase {
    
    func execute(othersUID: String?) async throws -> UserProfile {
        
        return UserProfile.stub(likedProductIds: [2,3,4,5])
    }
}

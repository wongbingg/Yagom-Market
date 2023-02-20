//
//  SearchOthersUIDUseCaseMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/20.
//

@testable import YagomMarket

final class SearchOthersUIDUseCaseMock: SearchOthersUIDUseCase {
    
    func execute(with vendorName: String) async throws -> UserUID {
        return UserUID(userUID: "")
    }
}

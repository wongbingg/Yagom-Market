//
//  KakaoServiceMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/03/02.
//

@testable import YagomMarket

final class KakaoServiceMock: KakaoService {
    func login(_ completion: @escaping (LoginInfo) -> Void) {
        let loginInfo = LoginInfo(id: "", password: "", vendorName: "", identifier: "", secret: "")
        completion(loginInfo)
    }
}

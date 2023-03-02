//
//  KakaoLoginUseCaseMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/03/02.
//

@testable import YagomMarket

final class KakaoLoginUseCaseMock: KakaoLoginUseCase {
    private let kakaoService: KakaoService
    
    init(kakaoServie: KakaoService) {
        self.kakaoService = kakaoServie
    }
    
    func execute(_ completion: @escaping (LoginInfo) -> Void) {
        kakaoService.login { loginIfo in
            //
        }
    }
}

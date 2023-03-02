//
//  KakaoLoginUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/03/02.
//

import Foundation

protocol KakaoLoginUseCase {
    func execute(_ completion: @escaping (LoginInfo) -> Void)
}

final class DefaultKakaoLoginUseCase: KakaoLoginUseCase {
    
    private let kakaoService: KakaoService
    
    init(kakaoService: KakaoService) {
        self.kakaoService = kakaoService
    }
    
    func execute(_ completion: @escaping (LoginInfo) -> Void) {
        kakaoService.login { loginInfo in
            completion(loginInfo)
        }
    }
}

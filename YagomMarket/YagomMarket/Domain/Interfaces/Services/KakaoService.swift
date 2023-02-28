//
//  KakaoService.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/28.
//

protocol KakaoService {
    func login(_ completion: @escaping (LoginInfo) -> Void)
}

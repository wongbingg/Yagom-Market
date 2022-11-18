//
//  RegisterProductAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/15.
//

import Foundation

struct RegisterProductAPI: API {
    typealias ResponseType = SearchProductDetailResponse
    var configuration: APIConfiguration
    
    init(configuration: APIConfiguration) {
        self.configuration = configuration
    }
}

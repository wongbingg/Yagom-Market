//
//  SearchProductDetailAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/15.
//

struct SearchProductDetailAPI: API {
    typealias ResponseType = SearchProductDetailResponse
    let configuration: APIConfiguration?
    
    init(configuration: APIConfiguration) {
        self.configuration = configuration
    }
}

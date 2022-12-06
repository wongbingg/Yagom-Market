//
//  SearchProductListAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

struct SearchProductListAPI: API {
    typealias ResponseType = SearchProductListResponse
    let configuration: APIConfiguration
    
    init(configuration: APIConfiguration) {
        self.configuration = configuration
    }
}

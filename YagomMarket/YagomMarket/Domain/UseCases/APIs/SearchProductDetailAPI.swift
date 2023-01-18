//
//  SearchProductDetailAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/15.
//

struct SearchProductDetailAPI: API {
    typealias ResponseType = SearchProductDetailResponse
    let configuration: APIConfiguration?
    
    init(productId: Int) {
        configuration = APIConfiguration(
            method: .get,
            base: URLCommand.host,
            path: URLCommand.products +
            URLCommand.productId(search: productId),
            parameters: nil
        )
    }
}

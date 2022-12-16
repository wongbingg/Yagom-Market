//
//  SearchProductListAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

struct SearchProductListAPI: API {
    typealias ResponseType = SearchProductListResponse
    var configuration: APIConfiguration?
    
    init(pageNumber: Int, itemPerPage: Int) {
        let param = makeParameter(
            pageNo: pageNumber,
            itemPerPage: itemPerPage
        )
        configuration = makeAPIConfiguration(with: param)
    }
    
    private func makeParameter(pageNo: Int, itemPerPage: Int) -> [String: Any] {
        return  ["page_no": pageNo, "items_per_page": itemPerPage]
    }
    
    private func makeAPIConfiguration(with param: [String: Any]?) -> APIConfiguration {
        return APIConfiguration(
            method: .get,
            base: URLCommand.host,
            path: URLCommand.products,
            parameters: param
        )
    }
}

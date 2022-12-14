//
//  ServerCheckAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

struct ServerCheckAPI: API {
    typealias ResponseType = String
    let configuration: APIConfiguration?
    
    init() {
        configuration = APIConfiguration(
            method: .get,
            base: URLCommand.host,
            path: URLCommand.healthChecker,
            parameters: nil
        )
    }
}

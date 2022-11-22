//
//  ServerCheckAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import Foundation

struct ServerCheckAPI: API {
    typealias ResponseType = String
    let configuration: APIConfiguration
    
    init(configuration: APIConfiguration) {
        self.configuration = configuration
    }
    
    static func execute(_ completion: @escaping (String) -> Void) {
        let apiConfig = APIConfiguration(method: .get,
                                         base: URLCommand.host,
                                         path: URLCommand.healthChecker,
                                         parameters: nil)
        let serverCheck = ServerCheckAPI(configuration: apiConfig)
        serverCheck.execute { result in
            switch result {
            case .success(let result):
                completion(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

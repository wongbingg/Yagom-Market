//
//  DeleteProductAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/16.
//

import Foundation

class DeleteProductAPI: API {
    typealias ResponseType = SearchProductDetailResponse
    typealias CompletionHandler = (Result<ResponseType, Error>) -> Void
    
    var configuration: APIConfiguration? = APIConfiguration()
    
    func execute(with deleteURI: String,
                       _ completionHandler: @escaping CompletionHandler) {
        let apiConfig = APIConfiguration(
            method: .delete,
            base: URLCommand.host,
            path: deleteURI,
            parameters: nil
        )
        configuration = apiConfig
        execute { result in
            switch result {
            case .success(let success):
                completionHandler(.success(success))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

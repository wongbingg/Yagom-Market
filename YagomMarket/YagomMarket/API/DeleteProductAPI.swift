//
//  DeleteProductAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/16.
//

import Foundation

class DeleteProductAPI: API, DeleteURITransferable {
    typealias ResponseType = SearchProductDetailResponse
    typealias Results = Result<ResponseType, Error>
    
    var configuration: APIConfiguration = APIConfiguration()
    
    func completeFetch(_ deleteURI: String,
                       _ completionHandler: @escaping (Results) -> Void) {
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

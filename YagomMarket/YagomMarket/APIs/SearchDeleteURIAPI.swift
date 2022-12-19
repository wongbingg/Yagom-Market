//
//  SearchDeleteURIAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/16.
//

struct SearchDeleteURIAPI: API {
    typealias ResponseType = String
    
    var configuration: APIConfiguration?
    
    init(productId: Int) {
        configuration = APIConfiguration(
            method: .post,
            base: URLCommand.host,
            path: URLCommand.products +
            URLCommand.productId(delete: productId),
            body: DeleteKeyRequestModel(secret: URLCommand.secretKey),
            parameters: nil
        )
    }
    
    func searchDeleteURI(_ completion: @escaping (Result<String, Error>) -> Void) {
        execute { result in
            switch result {
            case .success(let deleteURI):
                completion(.success(deleteURI))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

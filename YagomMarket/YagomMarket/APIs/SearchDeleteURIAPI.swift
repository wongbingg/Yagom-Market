//
//  SearchDeleteURIAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/16.
//

struct SearchDeleteURIAPI: API {
    typealias ResponseType = String
    
    var configuration: APIConfiguration?
    
    init(configuration: APIConfiguration) {
        self.configuration = configuration
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

//
//  SearchDeleteURIAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/16.
//

struct SearchDeleteURIAPI<T: Informable>: API where T.Results == Result<SearchProductDetailResponse, Error> {
    typealias ResponseType = String
    
    var configuration: APIConfiguration
    var delegate: T?
    
    init(configuration: APIConfiguration, delegate: T? = nil) {
        self.configuration = configuration
        self.delegate = delegate
    }
    
    func searchDeleteURI(_ completion: @escaping (Result<String, Error>) -> Void) {
        execute { result in
            switch result {
            case .success(let deleteURI):
                completion(.success(deleteURI))
                completeFetch(deleteURI)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func completeFetch(_ key: String) {
        delegate?.completeFetch(key, { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(String(describing: failure))
            }
        })
    }
}

//
//  SearchDeleteURIAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/16.
//

import Foundation

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
    
    private func execute(using client: APIClient = APIClient.shared,
                 _ completionHandler: @escaping (Result<ResponseType, Error>) -> Void) {
        guard let url = configuration.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = configuration.method.rawValue
        
        let rowData = DeleteKeyRequestModel(secret: URLCommand.secretKey)
        guard let encodedData = try? JSONEncoder().encode(rowData) else { return }
        urlRequest.setValue(URLCommand.identifier, forHTTPHeaderField: "identifier")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = encodedData
        
        client.requestData(with: urlRequest) { (result) in
            switch result {
            case .success(let data):
                let result = String(data: data, encoding: .utf8)!
                DispatchQueue.main.async {
                    completionHandler(.success(result))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

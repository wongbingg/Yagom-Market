//
//  API.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import Foundation

protocol API {
    associatedtype ResponseType: Decodable
    var configuration: APIConfiguration { get }
}

extension API {
    func execute(using client: APIClient = APIClient.shared,
                 _ completionHandler: @escaping (Result<ResponseType, Error>) -> Void) {
        guard let urlRequest = configuration.makeURLRequest() else { return }
        client.requestData(with: urlRequest) { (result) in
            switch result {
            case .success(let data):
                if ResponseType.self == String.self {
                    let result = String(data: data, encoding: .utf8)!
                    completionHandler(.success(result as! Self.ResponseType))
                    return
                }
                do {
//                    debugPrint(data.prettyPrintedJSONString!)
                    let result = try JSONDecoder().decode(ResponseType.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

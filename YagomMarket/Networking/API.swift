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
        guard var urlRequest = configuration.makeURLRequest() else { return }
        urlRequest.setValue(URLCommand.identifier, forHTTPHeaderField: "identifier") // 테스트용
        client.requestData(with: urlRequest) { (result) in
            switch result {
            case .success(let data):
                do {
//                    debugPrint(data.prettyPrintedJSONString!) // 테스트용
                    if ResponseType.self == String.self { // String인코딩이 되어야 할 경우만 예외적으로 처리해준 부분
                        let result = String(data: data, encoding: .utf8)!
                        completionHandler(.success(result as! Self.ResponseType))
                        return
                    }
                    
                    let result = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(.success(result))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

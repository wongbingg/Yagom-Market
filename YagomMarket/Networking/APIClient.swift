//
//  APIClient.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import Foundation

struct APIClient {
    static let shared = APIClient(sesseion: URLSession.shared)
    private let session: URLSession
    
    func requestData(with urlRequest: URLRequest,
                     completionHandler: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: urlRequest) { (data, response, error) in
            let successRange = 200..<300
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
            !successRange.contains(statusCode) {
                print("\(statusCode) 현재 코드 200~300 범위를 넘었기 때문에 실패")
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(error ?? APIError.unknown))
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(.success(data))
            }
        }.resume()
    }
    
    func requestData(with url: URL,
                     completionHandler: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: url) { (data, _, error)  in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(error ?? APIError.unknown))
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(.success(data))
            }
        }.resume()
    }
    
    init(sesseion: URLSession) {
        self.session = sesseion
    }
}

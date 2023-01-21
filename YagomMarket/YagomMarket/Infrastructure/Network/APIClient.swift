//
//  APIClient.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import Foundation

struct APIClient {
    typealias CompletionHandler = (Result<Data, Error>) -> Void
    static let shared = APIClient(sesseion: URLSession.shared)
    private let session: URLSession
    
    init(sesseion: URLSession) {
        self.session = sesseion
    }

    func requestData(with urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: urlRequest) // 여기서의 에러처리는?
        let successRange = 200..<300
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw APIError.unknown }
        guard successRange.contains(statusCode) else { throw APIError.response(statusCode) }
        return data
    }
}

//
//  APIClient.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import Foundation

struct APIClient {
    static let shared = APIClient(sesseion: URLSession.shared)
    private let session: URLSessionProtocol
    
    init(sesseion: URLSessionProtocol) {
        self.session = sesseion
    }

    func requestData(with urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: urlRequest, delegate: nil)
        let successRange = 200..<300
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw APIError.unknown }
        guard successRange.contains(statusCode) else { throw APIError.response(statusCode) }
        return data
    }
}

// MARK: - URLSessionProtocol
protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}


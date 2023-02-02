//
//  APIError.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import Foundation

enum APIError: LocalizedError, Equatable {
    case unknown
    case serverConnectError
    case response(Int)
    case invalidURL
    case invalidURLRequest
    case failToEncoding
    case failToParse
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error has occured."
        case .serverConnectError:
            return "서버에 연결할 수 없습니다."
        case .response(let code):
            return "현재 코드: \(code) \n 서버코드가 200~300 범위를 넘었습니다. 요청이 잘못되었습니다."
        case .invalidURL:
            return "잘못된 URL 입니다."
        case .invalidURLRequest:
            return "잘못된 URLRequest 입니다."
        case .failToEncoding:
            return "String encoding이 실패했습니다."
        case .failToParse:
            return "JSON decoding에 실패했습니다."
        }
    }
}

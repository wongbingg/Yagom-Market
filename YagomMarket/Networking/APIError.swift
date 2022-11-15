//
//  APIError.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import Foundation

enum APIError: LocalizedError {
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error has occured."
        }
    }
}

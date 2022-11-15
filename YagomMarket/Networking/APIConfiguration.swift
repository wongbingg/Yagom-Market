//
//  APIConfiguration.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum URLCommand {
    static let host = "https://openmarket.yagom-academy.kr/"
    static let healthChecker = "healthChecker"
    static let products = "api/products"
}

struct APIConfiguration {
    let method: HTTPMethod
    var url: URL?
    
    init(method: HTTPMethod,
         base: String,
         path: String,
         parameters: [String : String]?) {
        self.method = method
        self.url = makeURL(base: base, path: path, parameters: parameters)
    }
    
    private func makeQuery(with dic: [String: String]?) -> [URLQueryItem]? {
        guard let dic = dic else { return nil }
        var list: [URLQueryItem] = []
        for (index, value) in dic {
            list.append(URLQueryItem(name: index, value: value))
        }
        return list
    }
    
    private func makeURL(base: String,
                         path: String,
                         parameters: [String: String]?) -> URL? {
        guard var urlComponent = URLComponents(string: base + path) else { return nil }
        urlComponent.queryItems = makeQuery(with: parameters)
        return urlComponent.url
    }
}

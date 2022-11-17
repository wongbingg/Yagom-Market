//
//  APIConfiguration.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum URLCommand {
    static let host = "https://openmarket.yagom-academy.kr"
    static let healthChecker = "healthChecker"
    static let products = "/api/products"
    static let identifier = "c08f22e6-5f28-11ed-a917-e3ffa43330f7"
    static let secretKey = "nvjb13rd8y76lkzv2"
}

struct APIConfiguration {
    let method: HTTPMethod
    var parameters: [String: Any]?
    var body: ProductModel?
    var images: [UIImage?]?
    var url: URL?
    
    init(
        method: HTTPMethod,
        base: String,
        path: String,
        body: ProductModel? = nil,
        parameters: [String : Any]?,
        images: [UIImage?]? = nil
    ) {
        self.method = method
        self.parameters = parameters
        self.body = body
        self.images = images
        self.url = makeURL(base: base, path: path, parameters: parameters)
    }
    
    init() {
        self.method = .get
    }
    
    private func makeURL(base: String,
                         path: String,
                         parameters: [String: Any]?) -> URL? {
        var urlComponent = URLComponents(string: base)!
        urlComponent.path = path
        urlComponent.queryItems = makeQuery(with: parameters)
        return urlComponent.url
    }
    
    private func makeQuery(with dic: [String: Any]?) -> [URLQueryItem]? {
        guard let dic = dic else { return nil }
        var list: [URLQueryItem] = []
        for (index, value) in dic {
            if let value = value as? String {
                list.append(URLQueryItem(name: index, value: value))
            } else if let value = value as? Int {
                list.append(URLQueryItem(name: index, value: String(value)))
            } else if let value = value as? Double {
                list.append(URLQueryItem(name: index, value: String(value)))
            }
        }
        return list
    }
    
    func makeURLRequest() -> URLRequest? {
        guard let url = url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        guard let body = body else { return urlRequest }
        let boundary = UUID().uuidString
        let postBody = createPostBody(with: body, at: boundary)
        urlRequest.httpBody = postBody
        urlRequest.setValue(
            URLCommand.identifier,
            forHTTPHeaderField: "identifier"
        )
        urlRequest.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        return urlRequest
    }
    
    func createPostBody(with body: ProductModel, at boundary: String) -> Data? {
        var data = Data()
        guard let paramData = try? JSONEncoder().encode(body),
              let images = images else { return nil }
        let startBoundaryData = "\r\n--\(boundary)\r\n"
        data.appendString(startBoundaryData)
        data.appendString("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
        data.append(paramData)
        data.append(convertImages(images, using: boundary))
        data.appendString("\r\n--\(boundary)--\r\n")
        return data
    }
    
    private func convertImages(_ images: [UIImage?], using boundary: String) -> Data {
        var data = Data()
        for image in images {
            guard let image = image else { break }
            let imageData = image.convertToData()
            data.append(convertFileData(fieldName: "images", fileName: "abc",
                                        mimeType: "image/jpeg", fileData: imageData, using: boundary))
        }
        return data
    }
    
    private func convertFileData(fieldName: String, fileName: String,
                                 mimeType: String, fileData: Data,using boundary: String) -> Data {
        var data = Data()
        data.appendString("\r\n--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName).png\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data
    }
}

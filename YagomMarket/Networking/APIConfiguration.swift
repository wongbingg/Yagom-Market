//
//  APIConfiguration.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import UIKit

// MARK: - HTTP Method
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - URLCommand
enum URLCommand {
    static let host = "https://openmarket.yagom-academy.kr"
    static let healthChecker = "/healthChecker"
    static let products = "/api/products"
    static let identifier = "c08f22e6-5f28-11ed-a917-e3ffa43330f7"
    static let secretKey = "nvjb13rd8y76lkzv2"
    static let json = "application/json"
    
    static func productId(search id: Int) -> String {
        return "/\(id)"
    }
    
    static func productId(delete id: Int) -> String {
        return "/\(id)/archived"
    }
    
    static func multiPartFormData(using boundary: String) -> String {
        return "multipart/form-data; boundary=\(boundary)"
    }
}

//MARK: - APIConfiguration

struct APIConfiguration {
    let method: HTTPMethod
    var parameters: [String: Any]?
    var body: BodyType?
    var images: [UIImage?]?
    var url: URL?
    
    init(
        method: HTTPMethod,
        base: String,
        path: String,
        body: BodyType? = nil,
        parameters: [String : Any]?,
        images: [UIImage?]? = nil
    ) {
        self.method = method
        self.parameters = parameters
        self.body = body
        self.images = images
        self.url = makeURL(
            base: base,
            path: path,
            parameters: parameters
        )
    }
    
    init() {
        self.method = .get
    }
    
    func makeURLRequest() -> URLRequest? {
        guard let url = url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(URLCommand.identifier,
                            forHTTPHeaderField: "identifier")
        switch body {
        case is ProductModel:
            return addPOSTBody(in: urlRequest)
        case is EditProductModel:
            return addPATCHBody(in: urlRequest)
        case is DeleteKeyRequestModel:
            return addSearchDeleteKeyBody(in: urlRequest)
        default:
            return urlRequest
        }
    }
    
    private func makeURL(base: String,
                         path: String,
                         parameters: [String: Any]?) -> URL? {
        guard var urlComponent = URLComponents(string: base + path) else {
            return nil
        }
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
    
    private func addPOSTBody(in request: URLRequest) -> URLRequest {
        var urlRequest = request
        guard let body = body as? ProductModel else { return urlRequest }
        let boundary = UUID().uuidString
        let postBody = createPostBody(with: body, at: boundary)
        urlRequest.httpBody = postBody
        urlRequest.setContentType(URLCommand.multiPartFormData(using: boundary))
        return urlRequest
    }
    
    private func addPATCHBody(in request: URLRequest) -> URLRequest? {
        var urlRequest = request
        guard let body = body as? EditProductModel else { return nil }
        urlRequest.httpBody = body.encodeToData()
        urlRequest.setContentType(URLCommand.json)
        return urlRequest
    }
    
    private func addSearchDeleteKeyBody(in request: URLRequest) -> URLRequest? {
        var urlRequest = request
        guard let body = body as? DeleteKeyRequestModel else { return nil }
        urlRequest.httpBody = body.encodeToData()
        urlRequest.setContentType(URLCommand.json)
        return urlRequest
    }
    
    // MARK: - multipart/form-data
    private func createPostBody(with body: ProductModel,
                                at boundary: String) -> Data? {
        var data = Data()
        guard let paramData = try? JSONEncoder().encode(body),
              let images = images else { return nil }
        data.appendBoundary(boundary)
        data.appendContentDisposition(fieldName: "params")
        data.append(paramData)
        data.append(convertImages(images, using: boundary))
        data.appendBoundary(boundary+"--")
        return data
    }
    
    private func convertImages(_ images: [UIImage?],
                               using boundary: String) -> Data {
        var data = Data()
        var number = 1
        let imageCompressionHandler = ImageCompressHandler()
        let imageResizeHandler = ImageResizeHandler()
        imageCompressionHandler.setNext(handler: imageResizeHandler)
        
        for image in images {
            guard let image = image,
                  let imageData = imageCompressionHandler.handle(request: image) else {
                break
            }
            data.append(
                convertFileData(
                    fieldName: "images", fileName: "image\(number)",
                    mimeType: "image/jpeg", fileData: imageData,
                    using: boundary
                )
            )
            number += 1
        }
        return data
    }
    
    private func convertFileData(fieldName: String, fileName: String,
                                 mimeType: String, fileData: Data,
                                 using boundary: String) -> Data {
        var data = Data()
        data.appendBoundary(boundary)
        data.appendContentDisposition(fieldName: fieldName,
                                      fileName: fileName)
        data.appendContentType(mimeType: mimeType)
        data.append(fileData)
        data.appendString("\r\n")
        return data
    }
}

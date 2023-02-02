//
//  SearchProductListResponse.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import Foundation

// MARK: - Data Transfer Object

struct ProductListResponseDTO: Decodable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [PageDTO]
}

extension ProductListResponseDTO {
    struct PageDTO: Decodable, Equatable {
        let id: Int
        let vendorId: Int
        let vendorName: String
        let name: String
        let description: String
        let thumbnail: String
        let currency: Currency
        let price: Double
        let bargainPrice: Double
        let discountedPrice: Double
        let stock: Int
        let createdAt: String
        let issuedAt: String
        
        enum CodingKeys: String, CodingKey {
            case id, name, description, thumbnail, currency, price, stock, vendorName
            case vendorId = "vendor_id"
            case bargainPrice = "bargain_price"
            case discountedPrice = "discounted_price"
            case createdAt = "created_at"
            case issuedAt = "issued_at"
        }
    }
}

enum Currency: String, Codable {
    case KRW = "KRW"
    case USD = "USD"
}

// MARK: - Mappings to Domain

extension ProductListResponseDTO {
    func toDomain() -> [ProductCell] {
        var result = [ProductCell]()
        pages.forEach { pageDTO in
            result.append(pageDTO.toDomain())
        }
        return result
    }
    
    static func toMockData(hasNext: Bool) -> Self {
        return .init(pageNo: 1, itemsPerPage: 50, totalCount: 1,
                     offset: 1, limit: 1, lastPage: 1, hasNext: hasNext,
                     hasPrev: false,
                     pages: [
                        .init(id: 1, vendorId: 1, vendorName: "",
                              name: "", description: "", thumbnail: "",
                              currency: .KRW, price: 0.0, bargainPrice: 0.0,
                              discountedPrice: 0.0, stock: 0, createdAt: "", issuedAt: "")
                     ]
        )
    }
}

extension ProductListResponseDTO.PageDTO {
    func toDomain() -> ProductCell {
        return .init(id: id,
                     imageURL: thumbnail,
                     title: name,
                     description: description,
                     vendor: vendorName,
                     postDate: createdAt,
                     price: String(price),
                     currency: currency) // 날짜 몇일전 처리
    }
}

//
//  SearchProductListResponse.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import Foundation

struct SearchProductListResponse: Decodable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [Page]
}

struct Page: Decodable, Equatable {
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

enum Currency: String, Codable {
    case KRW = "KRW"
    case USD = "USD"
}

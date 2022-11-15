//
//  SearchProductDetailResponse.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/15.
//

import Foundation

struct SearchProductDetailResponse: Decodable {
    let id: Int
    let vendorId: Int
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
    let images: [Image]
    let vendors: Vendor
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail, currency, price, stock, images, vendors
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

struct Image: Decodable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case thumbnailUrl = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}

struct Vendor: Decodable {
    let id: Int
    let name: String
}

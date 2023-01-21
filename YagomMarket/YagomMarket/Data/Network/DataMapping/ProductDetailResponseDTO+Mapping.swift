//
//  SearchProductDetailResponse.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/15.
//

import Foundation

// MARK: - Data Transfer Object

struct ProductDetailResponseDTO: Decodable {
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
    let images: [ImageDTO]
    let vendors: VendorDTO
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail, currency, price, stock, images, vendors
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

extension ProductDetailResponseDTO {
    
    struct ImageDTO: Decodable {
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
    
    struct VendorDTO: Decodable {
        let id: Int
        let name: String
    }
}

// MARK: - Mappings to Domain

extension ProductDetailResponseDTO {
    func toDomain() -> ProductDetail {
        return .init(id: id,
                     imageURLs: images.map { $0.toDomain() },
                     price: String(price),
                     vendorName: vendors.toDomain(),
                     time: createdAt,
                     description: description,
                     name: name)
    }
}

extension ProductDetailResponseDTO.ImageDTO {
    func toDomain() -> String {
        return url
    }
}

extension ProductDetailResponseDTO.VendorDTO {
    func toDomain() -> String {
        return name
    }
}

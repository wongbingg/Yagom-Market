//
//  ProductEditRequestDTO.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/20.
//

import Foundation

struct ProductEditRequestDTO: BodyType {
    let name: String?
    let description: String?
    let thumbnailId: Int?
    let price: Double?
    let currency: Currency?
    let discountedPrice: Double?
    let stock: Int?
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case thumbnailId = "thumbnail_id"
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case secret
    }
    
    static func stub(name: String? = nil,
              description: String? = nil,
              thumbnailId: Int? = nil,
              price: Double? = nil,
              currency: Currency? = nil,
              discountedPrice: Double? = nil,
              stock: Int? = nil,
              secret: String = "") -> Self {
        .init(name: name,
              description: description,
              thumbnailId: thumbnailId,
              price: price,
              currency: currency,
              discountedPrice: discountedPrice,
              stock: stock,
              secret: secret)
    }
}

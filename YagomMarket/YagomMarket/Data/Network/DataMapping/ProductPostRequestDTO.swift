//
//  ProductPostRequestDTO.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/20.
//

import Foundation

struct ProductPostRequestDTO: BodyType {
    let name: String
    let description: String
    let price: Double
    let currency: Currency
    let discountedPrice: Double?
    let stock: Int?
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case secret
    }
    
    func toEditRequestDTO() -> ProductEditRequestDTO { // 추후 다른 방법으로 수정 
        return ProductEditRequestDTO(
            name: name,
            description: description,
            thumbnailId: nil,
            price: price,
            currency: currency,
            discountedPrice: discountedPrice,
            stock: stock,
            secret: URLCommand.secretKey
        )
    }
    
    static func stub(name: String = "",
              description: String = "",
              price: Double = 0.0,
              currency: Currency = .KRW,
              discountedPrice: Double? = nil,
              stock: Int? = nil,
              secret: String = "") -> Self {
        .init(name: name,
              description: description,
              price: price,
              currency: currency,
              discountedPrice: discountedPrice,
              stock: stock,
              secret: secret)
    }
}

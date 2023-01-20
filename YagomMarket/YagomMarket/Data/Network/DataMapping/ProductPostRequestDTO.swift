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
    
    func toEditModel() -> ProductEditRequestDTO {
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
}

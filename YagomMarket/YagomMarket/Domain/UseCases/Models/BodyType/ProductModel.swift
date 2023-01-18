//
//  RegisterProductModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/15.
//

import Foundation

struct ProductModel: BodyType {
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
    
    func translateToEditModel() -> EditProductModel {
        return EditProductModel(
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

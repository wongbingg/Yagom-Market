//
//  RegisterProductModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/15.
//

import Foundation

struct ProductModel: Codable, BodyType {
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
}

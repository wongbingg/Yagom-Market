//
//  EditProductModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/24.
//

import Foundation

struct EditProductModel: Codable, BodyType {
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
}

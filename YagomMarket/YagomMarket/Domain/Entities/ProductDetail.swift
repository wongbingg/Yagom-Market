//
//  ProductDetail.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/18.
//

struct ProductDetail {
    let id: Int
    let imageURLs: [String]
    let price: String
    let vendorName: String
    let time: String
    let description: String
    let name: String
}

extension ProductDetail {
    func toDTO() -> ProductPostRequestDTO {
        return .init(name: name,
                     description: description,
                     price: Double(price) ?? 0.0,
                     currency: .KRW,
                     discountedPrice: nil,
                     stock: 10,
                     secret: URLCommand.secretKey)
    }
}

//
//  ProductDetail.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/18.
//

struct ProductDetail: Equatable {
    let id: Int
    let imageURLs: [String]
    let price: String
    let currency: Currency
    let vendorName: String
    let time: String
    let description: String
    let name: String
    var isLiked: Bool
}

extension ProductDetail {
    func toDTO() -> ProductPostRequestDTO {
        return .init(name: name,
                     description: description,
                     price: Double(price) ?? 0.0,
                     currency: currency,
                     discountedPrice: nil,
                     stock: 10,
                     secret: URLCommand.secretKey)
    }
    
    func toCell() -> ProductCell {
        return .init(id: id,
                     imageURL: imageURLs[0],
                     title: name,
                     description: description,
                     vendor: vendorName,
                     postDate: time,
                     price: price,
                     currency: currency)
    }
    
    static func stub(id: Int = 0,
                     imageURLs: [String] = [],
                     price: String = "",
                     currency: Currency = .KRW,
                     vendorName: String = "",
                     time: String = "",
                     description: String = "",
                     name: String = "") -> Self {
        return .init(id: id,
                     imageURLs: imageURLs,
                     price: price,
                     currency: currency,
                     vendorName: vendorName,
                     time: time,
                     description: description,
                     name: name,
                     isLiked: false)
    }
}

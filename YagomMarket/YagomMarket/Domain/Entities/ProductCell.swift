//
//  ProductGridCell.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

struct ProductCell: Equatable {
    let id: Int
    let imageURL: String
    let title: String
    let description: String
    let vendor: String
    let postDate: String
    let price: String
    let currency: Currency
}

extension ProductCell {
    
    static func stub(
        id: Int = 1,
        imageURL: String = "",
        title: String = "",
        description: String = "",
        vendor: String = "",
        postDate: String = "",
        price: String = "",
        currency: Currency = .KRW
    ) -> ProductCell {
        
        return .init(id: id,
              imageURL: imageURL,
              title: title,
              description: description,
              vendor: vendor,
              postDate: postDate,
              price: price,
              currency: currency)
    }
    
}

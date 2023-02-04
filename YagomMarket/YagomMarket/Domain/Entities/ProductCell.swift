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
    
    static func stub() -> ProductCell {
        .init(id: 123,
              imageURL: "",
              title: "",
              description: "",
              vendor: "",
              postDate: "",
              price: "",
              currency: .KRW)
    }
    
}

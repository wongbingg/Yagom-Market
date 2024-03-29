//
//  EditProductAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/24.
//

import Foundation

struct EditProductAPI: API {
    typealias ResponseType = ProductDetailResponseDTO
    var configuration: APIConfiguration?
    
    init(editModel: ProductEditRequestDTO, productId: Int) {
        configuration = APIConfiguration(
            method: .patch,
            base: URLCommand.host,
            path: URLCommand.products +
            URLCommand.productId(search: productId),
            body: editModel,
            parameters: nil,
            images: nil
        )
    }
}

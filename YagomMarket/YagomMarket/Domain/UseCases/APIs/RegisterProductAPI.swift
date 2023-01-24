//
//  RegisterProductAPI.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/15.
//

import UIKit

struct RegisterProductAPI: API {
    typealias ResponseType = ProductDetailResponseDTO
    var configuration: APIConfiguration?
    
    init(model: RegisterModel) {
        configuration = APIConfiguration(
            method: .post,
            base: URLCommand.host,
            path: URLCommand.products,
            body: model.requestDTO,
            parameters: nil,
            images: model.images
        )
    }
}

struct RegisterModel {
    let requestDTO: ProductPostRequestDTO
    let images: [UIImage]?
}

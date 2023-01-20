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
    
    init(postModel: ProductPostRequestDTO, images: [UIImage]) {
        configuration = APIConfiguration(
            method: .post,
            base: URLCommand.host,
            path: URLCommand.products,
            body: postModel,
            parameters: nil,
            images: images
        )
    }
}

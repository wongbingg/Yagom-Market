//
//  RegisterViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/29.
//

import UIKit

protocol RegisterViewModelInput {
    func requestPost()
}

protocol RegisterViewModelOutput {
    
}

protocol RegisterViewModel: RegisterViewModelInput, RegisterViewModelOutput {}

final class DefaultRegisterViewModel: RegisterViewModel {
    private var model: ProductModel?
    private var images: [UIImage]?
    
    func adoptModel(with domain: ProductModel) {
        model = domain
    }
    
    func adoptImages(with imageArr: [UIImage]) {
        images = imageArr
    }
    
    func requestPost() {
        let apiConfig = APIConfiguration(
            method: .post,
            base: URLCommand.host,
            path: URLCommand.products,
            body: model,
            parameters: nil,
            images: images
        )
        let api = RegisterProductAPI(configuration: apiConfig)
        api.execute { result in
            switch result {
            case .success(_):
                print("성공")
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

//
//  RegisterViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/29.
//

import UIKit

protocol RegisterViewModelInput {
    func requestPost(_ completion: @escaping (String) -> Void)
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
    
    func requestPost(_ completion: @escaping (String) -> Void) {
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
                completion("게시 성공!")
            case .failure(let error as APIError):
                completion(error.errorDescription!)
            default:
                print("알 수 없는 오류 발생")
                completion("알 수 없는 오류 발생")
            }
        }
    }
}

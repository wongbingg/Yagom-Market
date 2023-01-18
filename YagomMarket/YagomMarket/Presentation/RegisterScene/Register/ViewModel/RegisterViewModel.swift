//
//  RegisterViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/29.
//

import UIKit

struct RegisterViewModelActions {
    let registerButtonTapped: () -> Void
}

protocol RegisterViewModelInput {
    func requestPost(_ completion: @escaping (String) -> Void)
    func requestPatch(with productId: Int, _ completion: @escaping () -> Void)
    func adoptModel(with domain: ProductModel)
    func adoptImages(with imageArr: [UIImage])
}

protocol RegisterViewModelOutput {
    var model: ProductModel? { get }
    var images: [UIImage]? { get }
}

protocol RegisterViewModel: RegisterViewModelInput, RegisterViewModelOutput {}

final class DefaultRegisterViewModel: RegisterViewModel {
    var model: ProductModel?
    var images: [UIImage]?
    private let actions: RegisterViewModelActions
    
    init(actions: RegisterViewModelActions) {
        self.actions = actions
    }
    func adoptModel(with domain: ProductModel) {
        model = domain
    }
    
    func adoptImages(with imageArr: [UIImage]) {
        images = imageArr
    }
    
    func requestPost(_ completion: @escaping (String) -> Void) {
        guard let model = model, let images = images else { return }
        let api = RegisterProductAPI(postModel: model, images: images)
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
    
    func requestPatch(with productId: Int, _ completion: @escaping () -> Void) {
        guard let editModel = model?.translateToEditModel() else { return }
        let api = EditProductAPI(editModel: editModel, productId: productId)
        api.execute { result in
            switch result {
            case .success(_):
                completion()
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

//
//  MyPageSceneDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

import UIKit

final class MyPageSceneDIContainer {
    // MARK: - MyPage
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController {
        let viewModel = makeMyPageViewModel(actions: actions)
        return MyPageViewController(with: viewModel)
    }
    
    func makeMyPageViewModel(actions: MyPageViewModelActions) -> MyPageViewModel {
        return DefaultMyPageViewModel(actions: actions)
    }
    
    // MARK: - MyPage Detail
//    func makeProductDetailViewController(productId: Int, actions: ProductDetailViewModelActions) -> ProductDetailViewController {
//        let viewModel = makeProductDetailViewModel(productId: productId, actions: actions)
//        return ProductDetailViewController(viewModel: viewModel)
//    }
//
//    func makeProductDetailViewModel(productId: Int,
//                                    actions: ProductDetailViewModelActions) -> ProductDetailViewModel {
//        return DefaultProductDetailViewModel(actions: actions, productId: productId)
//    }
    
    // MARK: - Modal View
    func makeRegisterViewController(model: ProductDetail?,
                                    actions: RegisterViewModelActions) -> RegisterViewController {
        let viewModel = makeRegisterViewModel(model: model, actions: actions)
        return RegisterViewController(with: viewModel)
    }
    
    func makeRegisterViewModel(model: ProductDetail?,
                               actions: RegisterViewModelActions) -> RegisterViewModel {
        return DefaultRegisterViewModel(model: model, actions: actions)
    }
    // MARK: - UseCase
    
    // MARK: - MyPage Flow Coordinator
    func makeMyPageFlowCoordinator(navigationController: UINavigationController) -> MyPageFlowCoordinator {
        
        return MyPageFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
    // Test
//    func makeMyPageFlowCoordinator(navigationController: UINavigationController) -> SearchFlowCoordinator {
//
//        return MyPageFlowCoordinator(navCon: navigationController, dependencies: self)
//    }
}

extension MyPageSceneDIContainer: MyPageFlowCoordinatorDependencies {}

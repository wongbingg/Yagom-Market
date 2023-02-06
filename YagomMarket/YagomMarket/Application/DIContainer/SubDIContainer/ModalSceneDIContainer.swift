//
//  ModalSceneDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/06.
//

import UIKit

final class ModalSceneDIContainer {
    // MARK: - Register
    func makeRegisterViewController(model: ProductDetail?,
                                    actions: RegisterViewModelActions) -> RegisterViewController {
        let viewModel = makeRegisterViewModel(model: model, actions: actions)
        return RegisterViewController(with: viewModel)
    }
    
    func makeRegisterViewModel(model: ProductDetail?,
                               actions: RegisterViewModelActions) -> RegisterViewModel {
        return DefaultRegisterViewModel(
            model: model,
            actions: actions,
            registerProductUseCase: makeRegisterProductUseCase(),
            editProductUseCase: makeEditProductUseCase()
        )
    }
    
    // MARK: - ImageViewer
    func makeImageViewerController(imageURLs: [String],
                                   currentPage: Int) -> ImageViewerViewController {
        return ImageViewerViewController(imageURLs: imageURLs, currentPage: currentPage)
    }
    
    // MARK: - UseCase
    func makeRegisterProductUseCase() -> RegisterProductUseCase {
        return DefaultRegisterProductUseCase(productsRepository: makeProductsRepository())
    }
    
    func makeEditProductUseCase() -> EditProductUseCase {
        return DefaultEditProductUseCase(productsRepository: makeProductsRepository())
    }
    
    // MARK: - Repositories
    func makeProductsRepository() -> ProductsRepository {
        return DefaultProductsRepository()
    }
    
    // MARK: - Modal Flow Coordinator
    func makeModalFlowCoordinator(navigationController: UINavigationController) -> ModalFlowCoordinator {
        
        return ModalFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

extension ModalSceneDIContainer: ModalFlowCoordinatorDependencies { }

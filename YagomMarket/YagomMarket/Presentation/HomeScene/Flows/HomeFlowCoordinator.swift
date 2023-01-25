//
//  HomeFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

protocol HomeFlowCoordinatorDependencies: AnyObject {
    func makeProductListViewController(actions: ProductListViewModelActions) -> ProductListViewController
    func makeProductDetailViewController(productId: Int,
                                         actions: ProductDetailViewModelActions) -> ProductDetailViewController
    func makeRegisterViewController(model: ProductDetail?,
                                    actions: RegisterViewModelActions) -> RegisterViewController
    func makeImageViewerController(imageURLs: [String],
                                   currentPage: Int) -> ImageViewerViewController
}

final class HomeFlowCoordinator {
    let userUID: String
    var navigationController: UINavigationController
    var dependencies: HomeFlowCoordinatorDependencies
    
    init(
        userUID: String,
        navigationController: UINavigationController,
        dependencies: HomeFlowCoordinatorDependencies
    ) {
        self.userUID = userUID
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func generate() -> ProductListViewController {
        let actions = ProductListViewModelActions(
            productTapped: productTapped(id:),
            registerTapSelected: registerTapSelected,
            searchTapSelected: searchTapSelected
        )
        let homeVC = dependencies.makeProductListViewController(actions: actions)
        return homeVC
    }
    
    // MARK: View Transition
    func productTapped(id: Int) {
        let actions = ProductDetailViewModelActions(
            imageTapped: imageTapped(imageURLs:currentPage:),
            showEditView: showEditView(model:)
        )
        let productDetailVC = dependencies.makeProductDetailViewController(
            productId: id,
            actions: actions
        )
        navigationController.pushViewController(productDetailVC, animated: true)
    }
    
    func registerTapSelected() {
        let actions = RegisterViewModelActions(registerButtonTapped: registerButtonTapped,
                                               editButtonTapped: editButtonTapped)
        let registerVC = dependencies.makeRegisterViewController(model: nil, actions: actions)
        registerVC.modalPresentationStyle = .overFullScreen
        navigationController.topViewController?.present(registerVC, animated: true)
    }
    
    func searchTapSelected() {
        let searchSceneDIContainer = SearchSceneDIContainer()
        let coordinator = searchSceneDIContainer.makeSearchFlowCoordinator(
            navigationController: navigationController
        )
        coordinator.start()
    }
    
    func imageTapped(imageURLs: [String], currentPage: Int) {
        let imageViewerVC = dependencies.makeImageViewerController(
            imageURLs: imageURLs,
            currentPage: currentPage
        )
        // CustomModal 설정
        navigationController.topViewController?.present(imageViewerVC, animated: true)
    }
    
    func showEditView(model: ProductDetail) {
        let actions = RegisterViewModelActions(
            registerButtonTapped: registerButtonTapped,
            editButtonTapped: editButtonTapped
        )
        let editModalVC = dependencies.makeRegisterViewController(
            model: model,
            actions: actions
        )
        //        editView.delegate = self
        editModalVC.modalPresentationStyle = .overFullScreen
        navigationController.topViewController?.present(editModalVC, animated: true)
    }
    
    func registerButtonTapped() {
        navigationController.topViewController?.dismiss(animated: true)
    }
    
    func editButtonTapped() {
        self.navigationController.topViewController?.dismiss(animated: true)
    }
}

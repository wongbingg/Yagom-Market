//
//  MyPageFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

import UIKit

protocol MyPageFlowCoordinatorDependencies: AnyObject {
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController
    func makeRegisterViewController(model: ProductDetail?,
                                    actions: RegisterViewModelActions) -> RegisterViewController
    func makeResultViewController(cells: [ProductCell],
                                  actions: ResultViewModelAction) -> ResultViewController
    func makeProductDetailViewController(productId: Int,
                                         actions: ProductDetailViewModelActions) -> ProductDetailViewController
    func makeImageViewerController(imageURLs: [String],
                                   currentPage: Int) -> ImageViewerViewController
}

final class MyPageFlowCoordinator {
    var navigationController: UINavigationController
    var dependencies: MyPageFlowCoordinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: MyPageFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func generate() -> MyPageViewController {
        let actions = MyPageViewModelActions(
            registerTapSelected: registerTapSelected,
            searchTapSelected: searchTapSelected,
            logoutCellTapped: logoutCellTapped,
            likedListCellTapped: likedListCellTapped,
            myProductListCellTapped: myProductListCellTapped
        )
        let myPageVC = dependencies.makeMyPageViewController(actions: actions)
        return myPageVC
    }
    
    // MARK: View Transition
    func registerTapSelected() {
        let actions = RegisterViewModelActions(
            registerButtonTapped: registerButtonTapped,
            editButtonTapped: editButtonTapped
        )
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
    
    func logoutCellTapped() {
        LoginCacheManager.removeLoginInfo()
        let loginSceneDIContainer = LoginSceneDIContainer()
        let coordinator = loginSceneDIContainer.makeLoginFlowCoordinator(
            navigationController: navigationController
        )
        coordinator.start()
    }
    
    func likedListCellTapped(with model: [ProductCell]) {
        let actions = ResultViewModelAction(
            cellTapped: cellTapped(at:)
        )
        let resultVC = dependencies.makeResultViewController(
            cells: model,
            actions: actions
        )
        navigationController.pushViewController(resultVC, animated: true)
    }
    
    func myProductListCellTapped(with model: [ProductCell]) {
        let actions = ResultViewModelAction(
            cellTapped: cellTapped(at:)
        )
        let resultVC = dependencies.makeResultViewController(
            cells: model,
            actions: actions
        )
        navigationController.pushViewController(resultVC, animated: true)
    }
    
    func cellTapped(at id: Int) {
        let actions = ProductDetailViewModelActions(
            imageTapped: imageTapped(imageURLs:currentPage:),
            showEditView: showEditView(model:)
        )
        let detailVC = dependencies.makeProductDetailViewController(productId: id, actions: actions)
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func imageTapped(imageURLs: [String], currentPage: Int) {
        let imageViewerVC = dependencies.makeImageViewerController(
            imageURLs: imageURLs,
            currentPage: currentPage
        )
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
        navigationController.topViewController?.dismiss(animated: true)
    }
}


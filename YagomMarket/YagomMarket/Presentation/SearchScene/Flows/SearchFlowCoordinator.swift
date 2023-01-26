//
//  SearchFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

protocol SearchFlowCoordinatorDependencies: AnyObject {
    func makeSearchViewController(actions: SearchViewModelActions) -> SearchViewController
    func makeResultViewController(model: ProductListResponseDTO, actions: ResultViewModelAction) -> ResultViewController
    
    func makeProductDetailViewController(productId: Int, actions: ProductDetailViewModelActions) -> ProductDetailViewController
    func makeRegisterViewController(model: ProductDetail?, actions: RegisterViewModelActions) -> RegisterViewController
    func makeImageViewerController(imageURLs: [String], currentPage: Int) -> ImageViewerViewController
}

final class SearchFlowCoordinator {
    var navigationController: UINavigationController?
    var dependencies: SearchFlowCoordinatorDependencies
    
    init(dependencies: SearchFlowCoordinatorDependencies) {
        self.dependencies = dependencies
    }
    
    // test
    init(
        navCon: UINavigationController,
        dependencies: SearchFlowCoordinatorDependencies
    ) {
        self.navigationController = navCon
        self.dependencies = dependencies
    }
    
    // test
    func start() {
        let actions = SearchViewModelActions(
            goToResultVC: goToResultVC(with:),
            goToHomeTab: goToHomeTab
        )
        let searchVC = dependencies.makeSearchViewController(actions: actions)
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func generate() -> SearchViewController {
        let actions = SearchViewModelActions(
            goToResultVC: goToResultVC(with:),
            goToHomeTab: goToHomeTab
        )
        let searchVC = dependencies.makeSearchViewController(
            actions: actions
        )
        return searchVC
    }
    
    // MARK: View Transition
    func goToResultVC(with model: ProductListResponseDTO) {
        let actions = ResultViewModelAction(
            cellTapped: cellTapped(at:)
        )
        let resultVC = dependencies.makeResultViewController(
            model: model,
            actions: actions
        )
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func goToHomeTab() {
        navigationController?.popViewController(animated: true)
        let tabBarController = navigationController?.topViewController as! TabBarController
        tabBarController.selectedIndex = 0
    }
    
    func cellTapped(at id: Int) {
        let actions = ProductDetailViewModelActions(
            imageTapped: imageTapped(imageURLs:currentPage:),
            showEditView: showEditView(model:)
        )
        let detailVC = dependencies.makeProductDetailViewController(productId: id, actions: actions)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func imageTapped(imageURLs: [String], currentPage: Int) {
        let imageViewerVC = dependencies.makeImageViewerController(
            imageURLs: imageURLs,
            currentPage: currentPage
        )
        navigationController?.topViewController?.present(imageViewerVC, animated: true)
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
        navigationController?.topViewController?.present(editModalVC, animated: true)
    }
    
    func registerButtonTapped() {
        navigationController?.topViewController?.dismiss(animated: true)
    }
    
    func editButtonTapped() {
        navigationController?.topViewController?.dismiss(animated: true)
    }
}

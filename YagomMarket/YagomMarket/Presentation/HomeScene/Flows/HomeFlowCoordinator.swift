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
    func makeModalFlowCoordinator(navigationController: UINavigationController) -> ModalFlowCoordinator
}

final class HomeFlowCoordinator {
    private let userUID: String
    private let modalFlowCoordinator: ModalFlowCoordinator
    private let navigationController: UINavigationController
    private let dependencies: HomeFlowCoordinatorDependencies
    
    init(
        userUID: String,
        navigationController: UINavigationController,
        dependencies: HomeFlowCoordinatorDependencies
    ) {
        self.userUID = userUID
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.modalFlowCoordinator = dependencies.makeModalFlowCoordinator(
            navigationController: navigationController
        )
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
    
    // MARK: - View Transition
    private func productTapped(id: Int) {
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
    
    private func registerTapSelected() {
        modalFlowCoordinator.presentRegisterVC(with: nil)
    }
    
    private func searchTapSelected() {
        let searchSceneDIContainer = SearchSceneDIContainer()
        let coordinator = searchSceneDIContainer.makeSearchFlowCoordinator(
            navigationController: navigationController
        )
        coordinator.start()
    }
    
    private func imageTapped(imageURLs: [String], currentPage: Int) {
        guard let productDetailVC = navigationController.topViewController as? ProductDetailViewController else { return }
        self.modalFlowCoordinator.presentImageViewerVC(
            imageURLs: imageURLs,
            currentPage: currentPage,
            delegate: productDetailVC
        )
    }
    
    private func showEditView(model: ProductDetail) {
        modalFlowCoordinator.presentRegisterVC(with: model)
    }
}

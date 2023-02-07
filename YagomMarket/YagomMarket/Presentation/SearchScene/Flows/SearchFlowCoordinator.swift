//
//  SearchFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

protocol SearchFlowCoordinatorDependencies: AnyObject {
    func makeSearchViewController(actions: SearchViewModelActions) -> SearchViewController
    func makeResultViewController(cells: [ProductCell],
                                  actions: ResultViewModelAction) -> ResultViewController
    func makeProductDetailViewController(productId: Int,
                                         actions: ProductDetailViewModelActions) -> ProductDetailViewController
    func makeModalFlowCoordinator(navigationController: UINavigationController) -> ModalFlowCoordinator
}

final class SearchFlowCoordinator {
    private let modalFlowCoordinator: ModalFlowCoordinator
    private let navigationController: UINavigationController
    private let dependencies: SearchFlowCoordinatorDependencies
    
    init(
        navCon: UINavigationController,
        dependencies: SearchFlowCoordinatorDependencies
    ) {
        self.navigationController = navCon
        self.dependencies = dependencies
        self.modalFlowCoordinator = dependencies.makeModalFlowCoordinator(
            navigationController: navigationController
        )
    }
    
    func start() {
        let actions = SearchViewModelActions(
            goToResultVC: goToResultVC(with:),
            goToHomeTab: goToHomeTab
        )
        let searchVC = dependencies.makeSearchViewController(actions: actions)
        navigationController.pushViewController(searchVC, animated: true)
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
    
    // MARK: - View Transition
    private func goToResultVC(with cells: [ProductCell]) {
        let actions = ResultViewModelAction(
            cellTapped: cellTapped(at:)
        )
        let resultVC = dependencies.makeResultViewController(
            cells: cells,
            actions: actions
        )
        navigationController.pushViewController(resultVC, animated: true)
    }
    
    private func goToHomeTab() {
        navigationController.popViewController(animated: true)
        let tabBarController = navigationController.topViewController as! TabBarController
        tabBarController.selectedIndex = 0
        navigationController.navigationBar.topItem?.title = "Home"
    }
    
    private func cellTapped(at id: Int) {
        let actions = ProductDetailViewModelActions(
            imageTapped: imageTapped(imageURLs:currentPage:),
            showEditView: showEditView(model:)
        )
        let detailVC = dependencies.makeProductDetailViewController(productId: id,
                                                                    actions: actions)
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    private func imageTapped(imageURLs: [String], currentPage: Int) {
        guard let productDetailVC = navigationController.topViewController as? ProductDetailViewController else { return }
        modalFlowCoordinator.presentImageViewerVC(
            imageURLs: imageURLs,
            currentPage: currentPage,
            delegate: productDetailVC
        )
    }
    
    private func showEditView(model: ProductDetail) {
        modalFlowCoordinator.presentRegisterVC(with: model)
    }
}

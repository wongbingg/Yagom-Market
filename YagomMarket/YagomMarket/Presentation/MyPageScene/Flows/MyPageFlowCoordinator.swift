//
//  MyPageFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/21.
//

import UIKit

protocol MyPageFlowCoordinatorDependencies: AnyObject {
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController
    
    func makeResultViewController(cells: [ProductCell],
                                  actions: ResultViewModelAction) -> ResultViewController
    
    func makeProductDetailViewController(
        productId: Int,actions: ProductDetailViewModelActions) -> ProductDetailViewController
    
    func makeModalFlowCoordinator(
        navigationController: UINavigationController) -> ModalFlowCoordinator
    
    func makeSearchFlowCoordinator(
        navigationController: UINavigationController) -> SearchFlowCoordinator
}

final class MyPageFlowCoordinator {
    private let modalFlowCoordinator: ModalFlowCoordinator
    private let searchFlowCoordinator: SearchFlowCoordinator
    private let navigationController: UINavigationController
    private let dependencies: MyPageFlowCoordinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: MyPageFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.modalFlowCoordinator = dependencies.makeModalFlowCoordinator(
            navigationController: navigationController
        )
        self.searchFlowCoordinator = dependencies.makeSearchFlowCoordinator(
            navigationController: navigationController
        )
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
    
    // MARK: - View Transition
    private func registerTapSelected() {
        modalFlowCoordinator.presentRegisterVC(with: nil)
    }
    
    private func searchTapSelected() {
        searchFlowCoordinator.start()
    }
    
    private func logoutCellTapped() {
        LoginCacheManager.removeLoginInfo()
        let loginSceneDIContainer = LoginSceneDIContainer()
        let coordinator = loginSceneDIContainer.makeLoginFlowCoordinator(
            navigationController: navigationController
        )
        coordinator.start()
    }
    
    private func likedListCellTapped(with model: [ProductCell]) {
        let actions = ResultViewModelAction(
            cellTapped: cellTapped(at:)
        )
        let resultVC = dependencies.makeResultViewController(
            cells: model,
            actions: actions
        )
        navigationController.pushViewController(resultVC, animated: true)
    }
    
    private func myProductListCellTapped(with model: [ProductCell]) {
        let actions = ResultViewModelAction(
            cellTapped: cellTapped(at:)
        )
        let resultVC = dependencies.makeResultViewController(
            cells: model,
            actions: actions
        )
        navigationController.pushViewController(resultVC, animated: true)
    }
    
    private func cellTapped(at id: Int) {
        let actions = ProductDetailViewModelActions(
            imageTapped: imageTapped(imageURLs:currentPage:),
            showEditView: showEditView(model:)
        )
        let detailVC = dependencies.makeProductDetailViewController(
            productId: id,
            actions: actions
        )
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    private func imageTapped(imageURLs: [String], currentPage: Int) {
        
        guard let productDetailVC = navigationController.topViewController as?
                ProductDetailViewController else { return }
        
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


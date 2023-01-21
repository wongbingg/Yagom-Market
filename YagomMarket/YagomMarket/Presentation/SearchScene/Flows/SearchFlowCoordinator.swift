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
    
    func start() {
//        let actions = SearchViewModelActions(goToResultVC: goToResultVC(with:))
//        let searchVC = dependencies.makeSearchViewController(actions: actions)
//        navCon.pushViewController(searchVC, animated: true)
//        navigationController = UINavigationController(rootViewController: searchVC)
//        let actions = ProductListViewModelActions(
//            productTapped: productTapped(id:),
//            anotherTabTapped: anotherTabTapped
//        )
//        let homeVC = dependencies.makeProductListViewController(actions: actions)
//        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func generate() -> UINavigationController? {
        let actions = SearchViewModelActions(goToResultVC: goToResultVC(with:))
        let searchVC = dependencies.makeSearchViewController(actions: actions)
        navigationController = UINavigationController(rootViewController: searchVC)
        return navigationController
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
        // CustomModal 설정
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
        print("등록버튼 탭") //dismiss 역할
    }
    
    func editButtonTapped() {
        print("수정버튼 탭") // dismiss 역할
    }
}

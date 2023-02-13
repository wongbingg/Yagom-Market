//
//  ModalFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/06.
//

import UIKit

protocol ModalFlowCoordinatorDependencies {
    
    func makeRegisterViewController(model: ProductDetail?,
                                    actions: RegisterViewModelActions) -> RegisterViewController
    
    func makeImageViewerController(
        imageURLs: [String],
        currentPage: Int,
        delegate: ImageViewerViewControllerDelegate) -> ImageViewerViewController
}

final class ModalFlowCoordinator {
    private let navigationController: UINavigationController
    private let dependencies: ModalFlowCoordinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: ModalFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func presentRegisterVC(with productDetail: ProductDetail?) {
        let actions = RegisterViewModelActions(
            registerButtonTapped: registerButtonTapped,
            editButtonTapped: editButtonTapped
        )
        let registerVC = dependencies.makeRegisterViewController(
            model: productDetail,
            actions: actions
        )
        registerVC.modalPresentationStyle = .overFullScreen
        
        navigationController.topViewController?.present(
            registerVC,
            animated: true
        )
    }
    
    func presentImageViewerVC(imageURLs: [String],
                              currentPage: Int,
                              delegate: ImageViewerViewControllerDelegate) {
        let imageViewerVC = dependencies.makeImageViewerController(
            imageURLs: imageURLs,
            currentPage: currentPage,
            delegate: delegate
        )
        imageViewerVC.modalPresentationStyle = .custom
        
        navigationController.topViewController?.present(
            imageViewerVC,
            animated: true
        )
    }
    
    private func registerButtonTapped() {
        navigationController.topViewController?.dismiss(animated: true)
    }
    
    private func editButtonTapped() {
        self.navigationController.topViewController?.dismiss(animated: true)
    }
}

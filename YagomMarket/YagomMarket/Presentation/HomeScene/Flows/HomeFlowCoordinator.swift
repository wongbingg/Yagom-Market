//
//  HomeFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

protocol HomeFlowCoordinatorDependencies: AnyObject {
    func makeProductListViewController(actions: ProductListViewModelActions) -> ProductListViewController
    func makeProductDetailViewController(productId: Int) -> ProductDetailViewController
}

final class HomeFlowCoordinator {
    var navigationController: UINavigationController?
    var dependencies: HomeFlowCoordinatorDependencies
    
    init(dependencies: HomeFlowCoordinatorDependencies) {
        self.dependencies = dependencies
    }
    
//    func start() {
//        let actions = ProductListViewModelActions(
//            productTapped: productTapped(id:),
//            anotherTabTapped: anotherTabTapped
//        )
//        let homeVC = dependencies.makeProductListViewController(actions: actions)
//        navigationController.pushViewController(homeVC, animated: true)
//    }
    // test
    func generate() -> UINavigationController? {
        let actions = ProductListViewModelActions(
            productTapped: productTapped(id:),
            anotherTabTapped: anotherTabTapped
        )
        let homeVC = dependencies.makeProductListViewController(actions: actions)
        navigationController = UINavigationController(rootViewController: homeVC)
        return navigationController
    }
    
    // MARK: View Transition
    func productTapped(id: Int) {
        let productDetailVC = dependencies.makeProductDetailViewController(productId: id)
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    func anotherTabTapped() {
        // 탭 이동 -- 고민
    }
}

//
//  SearchFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

protocol SearchFlowCoordinatorDependencies: AnyObject {
    func makeSearchViewController(actions: SearchViewModelActions) -> SearchViewController
}

final class SearchFlowCoordinator {
    var navigationController: UINavigationController?
    var dependencies: SearchFlowCoordinatorDependencies
    
    init(dependencies: SearchFlowCoordinatorDependencies) {
        self.dependencies = dependencies
    }
    
    func start() {
//        let actions = ProductListViewModelActions(
//            productTapped: productTapped(id:),
//            anotherTabTapped: anotherTabTapped
//        )
//        let homeVC = dependencies.makeProductListViewController(actions: actions)
//        navigationController.pushViewController(homeVC, animated: true)
    }
    // test
    func generate() -> UINavigationController? {
        let actions = SearchViewModelActions(cellTapped: cellTapped(name:))
        let searchVC = dependencies.makeSearchViewController(actions: actions)
        navigationController = UINavigationController(rootViewController: searchVC)
        return navigationController
    }
    
    // MARK: View Transition
    func cellTapped(name: String) {
        // 검색결과로 이동
    }    
}

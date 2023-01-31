//
//  AppFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

final class AppFlowCoordinator {
    
    private var navigationController: UINavigationController!
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let loginSceneDIContainer = appDIContainer.makeLoginSceneDIContainer()
        let flow = loginSceneDIContainer.makeLoginFlowCoordinator(
            navigationController: navigationController
        )
        if let loginInfo = LoginCacheManager.fetchPreviousInfo() {
            flow.successLogin(loginInfo)
        } else {
            flow.start()
        }
    }
}

//
//  AppFlowCoordinator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

final class AppFlowCoordinator {
    
    var window: UIWindow?
    private let appDIContainer: AppDIContainer
    
    init(window: UIWindow?, appDIContainer: AppDIContainer) {
        self.window = window
        self.appDIContainer = appDIContainer
    }
    
    func start() {
//        let loginSceneDIContainer = appDIContainer.makeLoginSceneDIContainer()
//        let flow = loginSceneDIContainer.makeLoginFlowCoordinator(
//            navigationController: navigationController
//        )
//        flow.start()
        
        let homeSceneDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let flow1 = homeSceneDIContainer.makeHomeFlowCoordinator(
            fireStoreCollectionId: "" // collectionId 들어가야됨
        )
        let homeVC = flow1.generate()
        
        let searchSceneDIContainer = appDIContainer.makeSearchSceneDIContainer()
        let flow2 = searchSceneDIContainer.makeSearchFlowCoordinator()
        let searchVC = flow2.generate()
        
        let registerSceneDIContainer = appDIContainer.makeRegisterSceneDIContainer()
        let flow3 = registerSceneDIContainer.makeRegisterFlowCoordinator()
        let registerVC = flow3.generate()
        
        let chatVC = ChatViewController()
        let myPageVC = MyPageViewController()
        
        let tabBarController = TabBarController(
            homeVC: homeVC!,
            searchVC: searchVC!,
            registerVC: registerVC,
            chatVC: chatVC,
            myPageVC: myPageVC
        )
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

//
//  SceneDelegate.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let appDIContainer = AppDIContainer()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
//        let tabBarController = TabBarController()
//        let navigationController = UINavigationController(rootViewController: tabBarController)
//        window?.rootViewController = navigationController
        
        let coordinator = AppFlowCoordinator(
            window: window,
            appDIContainer: appDIContainer
        )
        coordinator.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

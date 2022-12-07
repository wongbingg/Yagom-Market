//
//  TabBarController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
    }
    
    private func setupInitialView() {
        view.tintColor = .systemBrown
        let homeVC = HomeViewController()
        let registerVC = RegisterViewController()
        let searchVC = SearchViewController()

        homeVC.title = "Home"
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        let navHome = UINavigationController(rootViewController: homeVC)
        
        registerVC.title = "Register" // 등록하는게 의미가 없는 상태, 왜냐면 modal로 따로 띄워주는 중 
        registerVC.tabBarItem.image = UIImage(systemName: "plus.circle")
        let navRegister = UINavigationController(rootViewController: registerVC)
        
        searchVC.title = "Search"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        let navSearch = UINavigationController(rootViewController: searchVC)
        
        setViewControllers([navHome, navRegister, navSearch], animated: false)
    }
}

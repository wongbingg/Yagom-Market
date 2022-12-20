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
        let searchVC = SearchViewController()
        let registerVC = RegisterViewController()
        let chatVC = ChatViewController()
        let myPageVC = MyPageViewController()

        homeVC.title = "Home"
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        
        chatVC.title = "Chat"
        chatVC.tabBarItem.image = UIImage(systemName: "bubble.right")
        
        myPageVC.title = "MY"
        myPageVC.tabBarItem.image = UIImage(systemName: "person")
        
        registerVC.title = "Register"
        registerVC.tabBarItem.image = UIImage(systemName: "plus.circle")
        
        searchVC.title = "Search"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        setViewControllers([homeVC, searchVC, registerVC, chatVC, myPageVC], animated: false)
    }
}

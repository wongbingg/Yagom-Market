//
//  TabBarController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

final class TabBarController: UITabBarController {
    let homeVC: UINavigationController
    let searchVC: UINavigationController
    let registerVC: UIViewController
    let chatVC: UIViewController
    let myPageVC: UIViewController
    
    init(
        homeVC: UINavigationController,
        searchVC: UINavigationController,
        registerVC: UIViewController,
        chatVC: UIViewController,
        myPageVC: UIViewController
    ) {
        self.homeVC = homeVC
        self.searchVC = searchVC
        self.registerVC = registerVC
        self.chatVC = chatVC
        self.myPageVC = myPageVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
    }
    
    private func setupInitialView() {
        view.tintColor = .systemBrown

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

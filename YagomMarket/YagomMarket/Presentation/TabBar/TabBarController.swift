//
//  TabBarController.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

import UIKit

final class TabBarController: UITabBarController {
    let homeVC: ProductListViewController
    let searchVC: SearchViewController
    let registerVC: RegisterViewController
    let chatVC: ChattingListViewController
    let myPageVC: MyPageViewController
    
    init(
        homeVC: ProductListViewController,
        searchVC: SearchViewController,
        registerVC: RegisterViewController,
        chatVC: ChattingListViewController,
        myPageVC: MyPageViewController
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
        setupNavigationBar()
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
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
    }
}

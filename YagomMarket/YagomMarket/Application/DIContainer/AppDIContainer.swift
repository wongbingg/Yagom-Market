//
//  AppDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - DIContainers of scenes
    func makeLoginSceneDIContainer() -> LoginSceneDIContainer {
        return LoginSceneDIContainer()
    }
    
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        return HomeSceneDIContainer()
    }
    
    func makeSearchSceneDIContainer() -> SearchSceneDIContainer {
        return SearchSceneDIContainer()
    }
    
    func makeChatSceneDIContainer() -> ChatSceneDIContainer {
        return ChatSceneDIContainer()
    }
    
    func makeMyPageSceneDIContainer() -> MyPageSceneDIContainer {
        return MyPageSceneDIContainer()
    }
}

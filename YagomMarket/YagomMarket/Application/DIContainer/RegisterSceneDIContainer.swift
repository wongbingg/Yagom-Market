//
//  RegisterSceneDIContainer.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import UIKit

final class RegisterSceneDIContainer {
    // MARK: - Register
    func makeRegisterViewController(actions: RegisterViewModelActions) -> RegisterViewController {
        let viewModel = makeRegisterViewModel(actions: actions)
        return RegisterViewController(with: viewModel)
    }
    
    func makeRegisterViewModel(actions: RegisterViewModelActions) -> RegisterViewModel {
        return DefaultRegisterViewModel(actions: actions)
    }
    
    // MARK: - UseCase
    
    // MARK: - Register Flow Coordinator
    func makeRegisterFlowCoordinator() -> RegisterFlowCoordinator {
        
        return RegisterFlowCoordinator(dependencies: self)
    }
}

extension RegisterSceneDIContainer: RegisterFlowCoordinatorDependencies {}

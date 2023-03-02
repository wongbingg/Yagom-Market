//
//  FacebookLoginUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/03/02.
//

import UIKit

protocol FacebookLoginUseCase {
    func execute(in vc: UIViewController, _ completion: @escaping (LoginInfo) -> Void)
}

final class DefaultFacebookLoginUseCase: FacebookLoginUseCase {
    private let facebookService: FacebookService
    
    init(facebookService: FacebookService) {
        self.facebookService = facebookService
    }
    
    func execute(in vc: UIViewController, _ completion: @escaping (LoginInfo) -> Void) {
        facebookService.login(in: vc) { loginInfo in
            completion(loginInfo)
        }
    }
}

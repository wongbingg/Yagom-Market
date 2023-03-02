//
//  FacebookLoginUseCaseMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/03/02.
//

import UIKit
@testable import YagomMarket

final class FacebookLoginUseCaseMock: FacebookLoginUseCase {
    private let facebookService: FacebookService
    
    init(facebookService: FacebookService) {
        self.facebookService = facebookService
    }
    
    func execute(in vc: UIViewController, _ completion: @escaping (LoginInfo) -> Void) {
        facebookService.login(in: UIViewController()) { loginIfo in
            //
        }
    }
}

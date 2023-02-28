//
//  DefaultFacebookService.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/28.
//

import FacebookLogin

final class DefaultFacebookService: FacebookService {
    private let loginManager = LoginManager()
    
    var isLoggedin: Bool {
        if let token = AccessToken.current, !token.isExpired {
            return true
        } else {
            return false
        }
    }
    
    func login(in viewController: UIViewController, _ completion: @escaping (LoginInfo) -> Void) {
        loginManager.logIn(permissions: ["public_profile","email"], from: viewController) { result, error in
            if let error = error {
                print(error)
            } else if let result = result, result.isCancelled {
                print("login is cancelled")
            } else {
                print("success FacebookLogin")
                Profile.loadCurrentProfile { profile, error in
                    if let error = error {
                        print(error)
                    } else if let email = profile?.email {
                        let loginInfo = LoginInfo(
                            id: email,
                            password: email + "PasswordLogic",
                            vendorName: "", identifier: "", secret: ""
                        )
                        
                        completion(loginInfo)
                    }
                }
            }
        }
    }
}

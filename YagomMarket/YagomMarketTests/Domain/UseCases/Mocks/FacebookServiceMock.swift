//
//  FacebookServiceMock.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/03/02.
//

@testable import YagomMarket
import UIKit

final class FacebookServiceMock: FacebookService {
    
    func login(in viewController: UIViewController, _ completion: @escaping (LoginInfo) -> Void) {
        let loginInfo = LoginInfo(id: "", password: "", vendorName: "", identifier: "", secret: "")
        completion(loginInfo)
    }
}

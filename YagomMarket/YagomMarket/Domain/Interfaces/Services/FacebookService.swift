//
//  FacebookService.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/28.
//

import UIKit

protocol FacebookService {
    func login(in viewController: UIViewController, _ completion: @escaping (LoginInfo) -> Void)
}

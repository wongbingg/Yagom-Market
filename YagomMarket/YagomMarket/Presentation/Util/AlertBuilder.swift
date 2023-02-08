//
//  AlertBuilder.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/13.
//

import UIKit

enum AlertTitle: String {
    case alert = "알림"
    case warning = "경고"
    case error = "에러"
}

enum AlertButton: String {
    case confirm = "확인"
    case cancel = "취소"
    case yes = "예"
    case no = "아니요"
    case edit = "수정"
    case delete = "삭제"
}

protocol AlertBuilder {
    var alertController: UIAlertController { get }
    
    func setButton(name: AlertButton,
                   style: UIAlertAction.Style,
                   _ completion: (() -> Void)?) -> Self
    func showAlert(on viewController: UIViewController)
}

final class DefaultAlertBuilder: AlertBuilder {
    var alertController: UIAlertController
    
    init(
        title: AlertTitle = .alert,
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .alert
    ) {
        alertController = UIAlertController(
            title: title.rawValue,
            message: message,
            preferredStyle: preferredStyle
        )
    }
    
    func setButton(name: AlertButton = .confirm,
                   style: UIAlertAction.Style = .default,
                   _ completion: (() -> Void)? = nil) -> DefaultAlertBuilder {
        
        let button = UIAlertAction(title: name.rawValue, style: style) { alertAction in
            completion?()
        }
        alertController.addAction(button)
        
        return self
    }
    
    func showAlert(on viewController: UIViewController) {
        viewController.present(alertController, animated: true)
    }
}

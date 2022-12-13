//
//  AlertManager.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/12.
//

import UIKit

protocol AlertManagerInput {
    var description: String { get set }
    var title: String { get set }
}

protocol AlertManagerOutput {
    func showAlert(on viewController: UIViewController)
}

struct AlertManger: AlertManagerInput, AlertManagerOutput {
    var description: String
    
    var title: String
    
    func showAlert(on viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { action in
            if description == "게시 성공!" {
                viewController.dismiss(animated: true)
            }
        }
        alertController.addAction(confirmAction)
        viewController.present(alertController, animated: true)
    }
}

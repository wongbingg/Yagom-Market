//
//  Handler.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/13.
//

import UIKit

protocol Handler: AnyObject {
    var nextHandler: Handler? { get set }
    
    @discardableResult
    func setNext(handler: Handler) -> Handler
    
    func handle(request: UIImage) -> Data?
}

extension Handler {
    @discardableResult
    func setNext(handler: Handler) -> Handler {
        self.nextHandler = handler
        return handler
    }
}

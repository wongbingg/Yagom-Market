//
//  Observable.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/12/02.
//

class Observable<T> {
    var value: T {
        didSet {
            listener?(value)
        }
    }
    var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void ) {
        closure(value)
        self.listener = closure
    }
}

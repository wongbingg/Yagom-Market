//
//  Informable.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/17.
//

protocol Informable {
    associatedtype Results
    
    func completeFetch(
        _ deleteURI: String,
        _ completionHandler: @escaping (Results) -> Void
    )
}

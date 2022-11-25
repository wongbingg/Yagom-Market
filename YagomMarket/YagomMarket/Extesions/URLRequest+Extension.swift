//
//  URLRequest+Extension.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/25.
//

import Foundation

extension URLRequest {
    mutating func setValues(identifier: String, contentType: String) {
        self.setValue(
            identifier,
            forHTTPHeaderField: "identifier"
        )
        self.setValue(
            contentType,
            forHTTPHeaderField: "Content-Type"
        )
    }
}

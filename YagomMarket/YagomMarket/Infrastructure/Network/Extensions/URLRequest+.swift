//
//  URLRequest+Extension.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/25.
//

import Foundation

extension URLRequest {
    
    mutating func setContentType(_ contentType: String) {
        self.setValue(contentType, forHTTPHeaderField: "Content-Type")
    }
}

//
//  Bundle+.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import Foundation

extension Bundle {
    var identifier: String {
        guard let file = self.path(forResource: "API_Info", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["Identifier"] as? String else { fatalError("API_Info에 Identifier 값을 입력 해주세요.")}
        return key
    }
    
    var secretKey: String {
        guard let file = self.path(forResource: "API_Info", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["Secret_KEY"] as? String else { fatalError("API_Info에 Secret_KEY 값을 입력 해주세요.")}
        return key
    }
}

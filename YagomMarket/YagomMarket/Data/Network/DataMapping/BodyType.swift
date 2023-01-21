//
//  BodyType.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/24.
//

import Foundation

protocol BodyType: Codable {
    func encodeToData() -> Data?
}

extension BodyType {
    
    func encodeToData() -> Data? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return data
    }
}

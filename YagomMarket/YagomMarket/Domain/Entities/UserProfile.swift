//
//  UserProfile.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

import Foundation

struct UserProfile {
    let name: String
    let email: String
    var likedProductIds: [Int]
    
    func toDictionary() -> Dictionary<String, Any> {
        return ["name": name, "email": email, "likedProductIds": likedProductIds]
    }
}

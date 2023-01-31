//
//  UserProfile.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/24.
//

import Foundation
import FirebaseFirestore

struct UserProfile: Entity {
    let vendorName: String
    let email: String
    var likedProductIds: [Int]
    
    func toDictionary() -> Dictionary<String, Any> {
        return ["vendorName": vendorName, "email": email, "likedProductIds": likedProductIds]
    }
    
    func toEntity(with documentSnapshot: DocumentSnapshot) -> UserProfile {
        return .init(vendorName: documentSnapshot.get("vendorName") as! String,
                     email: documentSnapshot.get("email") as! String,
                     likedProductIds: documentSnapshot.get("likedProductIds") as! [Int])
    }
}

extension UserProfile {
    init () {
        self.vendorName = ""
        self.email = ""
        self.likedProductIds = []
    }
}

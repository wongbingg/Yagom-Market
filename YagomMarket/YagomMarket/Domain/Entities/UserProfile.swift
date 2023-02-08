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
    var chattingUUIDList: [String]
    
    func toDictionary() -> Dictionary<String, Any> {
        return ["vendorName": vendorName,
                "email": email,
                "likedProductIds": likedProductIds,
                "chattingUUIDList": chattingUUIDList]
    }
    
    static func toEntity(with documentSnapshot: DocumentSnapshot) throws -> UserProfile {
        guard let vendorName = documentSnapshot.get("vendorName") as? String,
              let email = documentSnapshot.get("email") as? String,
              let likedProductIds = documentSnapshot.get("likedProductIds") as? [Int],
              let chattingUUIDList = documentSnapshot.get("chattingUUIDList") as? [String] else {
            
            throw FirestoreServiceError.failToRead
        }
        
        return .init(vendorName: vendorName,
                     email: email,
                     likedProductIds: likedProductIds,
                     chattingUUIDList: chattingUUIDList)
    }
}

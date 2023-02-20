//
//  UserUID.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/09.
//

import FirebaseFirestore

struct UserUID: Entity {
    let userUID: String
    
    func toDictionary() -> Dictionary<String, Any> {
        return ["userUID": userUID]
    }
    
    static func toEntity(with documentSnapshot: DocumentSnapshot) throws -> UserUID {
        
        guard let userUID = documentSnapshot.get("userUID") as? String else {
            throw FirestoreServiceError.failToRead
        }
        
        return .init(userUID: userUID)
    }
    
    static func stub(userUID: String = "") -> Self {
        .init(userUID: userUID)
    }
}

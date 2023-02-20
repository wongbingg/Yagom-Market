//
//  Message.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/08.
//

import Foundation
import FirebaseFirestore

struct Message: Entity {
    let body: String
    let sender: String
    let time: String
    
    func toDictionary() -> Dictionary<String, Any> {
        return ["body": body, "sender": sender, "time": time]
    }
    
    static func toEntity(with documentSnapshot: DocumentSnapshot) throws -> Message {
        guard let body = documentSnapshot.get("body") as? String,
              let sender = documentSnapshot.get("sender") as? String,
              let time = documentSnapshot.get("time") as? String else {
            
            throw FirestoreServiceError.failToRead
        }
        
        return .init(body: body, sender: sender, time: time)
    }
    
    static func stub(body: String = "",
                     sender: String = "",
                     time: String = "") -> Self {
        .init(body: body,
              sender: sender,
              time: time)
    }
}

//
//  DefaultFirestoreStream.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/13.
//

import FirebaseFirestore

final class DefaultFirestoreStream: FirestoreStream {
    let firestoreDatabase = Firestore.firestore()
    var listener: ListenerRegistration?
    var messageListener: CollectionReference?
    
    init(chattingUUID: String) {
        messageListener  = firestoreDatabase.collection(chattingUUID)
    }
    
    func subscribe(completion: @escaping ([DocumentChange]) -> Void) {
        messageListener?.addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot else {
                return // error
            }
            let result = snapshot.documentChanges
            completion(result)
        })
    }
    
    func removeListener() {
        listener?.remove()
    }
}

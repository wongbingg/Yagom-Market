//
//  FirestoreStream.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/13.
//

import FirebaseFirestore

protocol FirestoreStream {
    func subscribe(completion: @escaping ([DocumentChange]) -> Void)
    func removeListener()
}

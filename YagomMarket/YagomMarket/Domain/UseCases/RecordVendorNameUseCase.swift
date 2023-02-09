//
//  RecordVendorNameUseCase.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/09.
//

import Foundation

protocol RecordVendorNameUseCase {
    func execute(with vendorName: String?) async throws
}

final class DefaultRecordVendorNameUseCase: RecordVendorNameUseCase {
    private let firebaseAuthService: FirebaseAuthService
    private let firestoreService: any FirestoreService
    
    init(
        firebaseAuthService: FirebaseAuthService,
        firestoreService: any FirestoreService
    ) {
        self.firebaseAuthService = firebaseAuthService
        self.firestoreService = firestoreService
    }
    
    func execute(with vendorName: String?) async throws {
        guard let vendorName = vendorName else { return }
        let userUID = try firebaseAuthService.fetchUserUID()
        
        try await firestoreService.create(
            collectionId: "vendorNameToUserUID",
            documentId: vendorName,
            entity: UserUID(userUID: userUID)
        )
    }
}

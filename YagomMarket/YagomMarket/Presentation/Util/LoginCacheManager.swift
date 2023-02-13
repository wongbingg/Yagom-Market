//
//  LoginCacheManager.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import Foundation

struct LoginCacheManager {
    static func setNewLoginInfo(userUID: String,
                                identifier: String,
                                secret: String,
                                vendorName: String) {
        
        let info = userUID + "%" + identifier + "%" + secret + "%" + vendorName
        UserDefaults.standard.set(info, forKey: "loginInfo")
    }
    
    static func fetchPreviousInfo() -> (userUID: String,
                                        identifier: String,
                                        secret: String,
                                        vendorName: String)? {
        
        guard let loginInfo = UserDefaults.standard.string(forKey: "loginInfo") else { return nil }
        let userUID = String(loginInfo.split(separator: "%")[0])
        let identifier = String(loginInfo.split(separator: "%")[1])
        let secret = String(loginInfo.split(separator: "%")[2])
        let vendorName = String(loginInfo.split(separator: "%")[3])
        return (userUID, identifier, secret, vendorName)
    }
    
    static func removeLoginInfo() {
        UserDefaults.standard.removeObject(forKey: "loginInfo")
    }
}

enum LoginCacheManagerError: LocalizedError {
    case noPreviousInfo
    
    var errorDescription: String? {
        switch self {
        case .noPreviousInfo:
            return "이전에 저장된 정보가 없습니다."
        }
    }
}

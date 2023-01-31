//
//  LoginCacheManager.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import Foundation

struct LoginCacheManager {
    static func setNewLoginInfo(_ info: String) {
        UserDefaults.standard.set(info, forKey: "loginInfo")
    }
    
    static func fetchPreviousInfo() -> String? {
        return UserDefaults.standard.string(forKey: "loginInfo")
    }
    
    static func removeLoginInfo() {
        UserDefaults.standard.removeObject(forKey: "loginInfo")
    }
}

enum LoginCacheError: LocalizedError {
    case noPreviousInfo
    
    var errorDescription: String? {
        switch self {
        case .noPreviousInfo:
            return "이전에 저장된 정보가 없습니다."
        }
    }
}

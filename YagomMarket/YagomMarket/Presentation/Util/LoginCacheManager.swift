//
//  LoginCacheManager.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import Foundation

struct LoginCacheManager {
    func setNewLoginInfo(_ info: String) {
        UserDefaults.standard.set(info, forKey: "loginInfo")
    }
    
    func fetchPreviousInfo() -> String? {
        return UserDefaults.standard.string(forKey: "loginInfo")
    }
    
    func removeLoginInfo() {
        UserDefaults.standard.removeObject(forKey: "loginInfo")
    }
}

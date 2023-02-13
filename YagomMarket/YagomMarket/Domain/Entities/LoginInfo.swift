//
//  LoginInfo.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/17.
//

import Foundation

struct LoginInfo {
    let id: String
    let password: String
    let vendorName: String
    let identifier: String
    let secret: String
    
    func validate() throws {
        guard id.contains("@") && id.contains(".") else {
            throw LoginError.invalidEmail
        }
        guard password.count >= 6 else {
            throw LoginError.invalidPassword(number: password.count)
        }
    }
}

enum LoginError: LocalizedError, Equatable {
    case invalidEmail
    case invalidPassword(number: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "이메일 형식이 잘못되었습니다."
        case .invalidPassword(let number):
            return "비밀번호를 6자리 이상 입력해주세요. \n현재 \(number)자리 입니다"
        }
    }
}

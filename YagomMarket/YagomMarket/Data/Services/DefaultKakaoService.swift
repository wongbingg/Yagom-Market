//
//  DefaultKakaoService.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/28.
//

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class DefaultKakaoService: KakaoService {
    
    func login(_ completion: @escaping (LoginInfo) -> Void) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    _ = oauthToken
                    UserApi.shared.me { user, error in
                        guard let user = user,
                              let email = user.kakaoAccount?.email else { return }
                        let loginInfo = LoginInfo(
                            id: email,
                            password: email + "passwordLogic",
                            vendorName: "", identifier: "", secret: "")
                        completion(loginInfo)
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success")
                    
                    _ = oauthToken
                    UserApi.shared.me { user, error in
                        guard let user = user,
                              let email = user.kakaoAccount?.email else { return }
                        let loginInfo = LoginInfo(
                            id: email,
                            password: email + "passwordLogic",
                            vendorName: "", identifier: "", secret: "")
                        completion(loginInfo)
                    }
                }
            }
        }
    }
    
    func logout() {
        UserApi.shared.logout { error in
            guard error == nil else {
                print(error)
                return
            }
        }
    }
}

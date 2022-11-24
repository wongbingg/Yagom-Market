//
//  DeleteKeyRequestModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/16.
//

import Foundation

struct DeleteKeyRequestModel: Codable, BodyType {
    let secret: String
}

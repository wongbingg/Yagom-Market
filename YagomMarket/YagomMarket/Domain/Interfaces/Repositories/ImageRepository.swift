//
//  ImageRepository.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/20.
//

import Foundation

protocol ImageRepository {
    func fetchImage(with imagePath: String) async throws-> Data
}

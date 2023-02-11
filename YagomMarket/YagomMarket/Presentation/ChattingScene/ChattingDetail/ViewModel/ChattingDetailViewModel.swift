//
//  ChattingDetailViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/02/09.
//

import Foundation

protocol ChattingDetailViewModelInput {}
protocol ChattingDetailViewModelOutput {}
protocol ChattingDetailViewModel: ChattingDetailViewModelInput, ChattingDetailViewModelOutput {}

final class DefaultChattingDetailViewModel: ChattingDetailViewModel {
    
}

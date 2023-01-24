//
//  DateCalculator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/30.
//

import Foundation

final class DateCalculator { // 12시 넘어서 올리면 오늘이라고 안뜨고 1일전 이라고 뜸.. 현재시간 제대로 측정 되는지 확인필요. createAt 시간 변환 제대로 되는지 확인 필요.
    private let dateFormatter = DateFormatter()
    private let calendar = Calendar.current
    static let shared = DateCalculator()
    
    private init(){
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    func calculatePostedDay(with createdAt: String) -> String {
        guard let postedDate = dateFormatter.date(from: createdAt),
              let distanceDay = Calendar.current.dateComponents([.day], from: postedDate, to: Date()).day else { return "" }
        if distanceDay == 0 {
            return "오늘"
        } else if distanceDay < 30 {
            return "\(distanceDay)일 전"
        } else {
            return "\(distanceDay/30)달 전"
        }
    }
}

//
//  DateCalculator.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/30.
//

import Foundation

final class DateCalculator {
    static let shared = DateCalculator()
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    
    private init(){
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }

    func calculatePostedDay(with createdAt: String ) -> String {
        let nowComponents = calendar.dateComponents([.day, .month], from: Date())
        
        guard let nowDay = nowComponents.day,
              let nowMonth = nowComponents.month,
              let postedDate = dateFormatter.date(from: createdAt) else { return "" }
        
        let postedDateComponents = calendar.dateComponents([.day, .month], from: postedDate)
        
        guard let postedDay = postedDateComponents.day,
              let postedMonth = postedDateComponents.month else { return "" }
        
        if nowMonth > postedMonth {
            return "\(nowMonth - postedMonth)달 전"
        } else if nowDay - postedDay == 0 {
                return "오늘"
        } else {
            return "\(nowDay - postedDay)일 전"
        }
    }
}

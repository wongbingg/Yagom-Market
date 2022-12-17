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

//
//  FreeDay.swift
//  TimetableManager
//
//  Created by Krzysztof on 15/11/2024.
//

import Foundation
import SwiftData

@Model
class FreeDay {
    var title: String
    var startDate: Date
    var endDate: Date
    
    init(title: String? = nil, startDate: Date, endDate: Date? = nil) {
        self.startDate = startDate
        self.endDate = endDate ?? startDate
        
        if let title = title {
            self.title = title
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            formatter.locale = Locale(identifier: "pl_PL")
            self.title = "Free \(formatter.string(from: startDate))"
        }
    }
    
    init(freeDay: FreeDay) {
        self.startDate = freeDay.startDate
        self.endDate = freeDay.endDate
        self.title = freeDay.title
    }
    
    static let sampleData: [FreeDay] = [
        FreeDay(title: "Dzień uniwersytetu", startDate: dateFromString("15-11-2024")),
        FreeDay(title: "Święta", startDate: dateFromString("20-12-2024"), endDate: dateFromString("24-12-2024"))
    ]
    
    static let genericFreeDay = FreeDay(startDate: Date())
    
    func isInRange(date: Date) -> Bool {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)

        let start = calendar.startOfDay(for: self.startDate)
        let end = calendar.startOfDay(for: self.endDate)
        
        return (start <= normalizedDate) && (normalizedDate <= end)
    }
}


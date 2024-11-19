//
//  SwapDate.swift
//  TimetableManager
//
//  Created by Krzysztof on 15/11/2024.
//

import Foundation
import SwiftData

@Model
class SwapDate {
    var date: Date
    var swapDate: Date
    
    init(date: Date, swapDate: Date) {
        self.date = date
        self.swapDate = swapDate
    }
    
    init(swapDate: SwapDate) {
        self.date = swapDate.date
        self.swapDate = swapDate.swapDate
    }
    
    
    static let sampleData: [SwapDate] = [
        SwapDate(date: dateFromString("20-11-2024"), swapDate: dateFromString("22-11-2024"))
    ]
    
    static let genericSwapDate = SwapDate(date: Date(), swapDate: Date())
    
    func isDate(date: Date) -> Bool {
        let calendar = Calendar.current
        
        let normalizedDate = calendar.startOfDay(for: date)
        let thisDay = calendar.startOfDay(for: self.date)
        
        return normalizedDate == thisDay
    }
}

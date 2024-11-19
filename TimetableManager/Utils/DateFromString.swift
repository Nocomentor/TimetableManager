//
//  DateFromString.swift
//  TimetableManager
//
//  Created by Krzysztof on 15/11/2024.
//

import Foundation

func dateFromString(_ dateString: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    formatter.locale = Locale(identifier: "pl_PL")
    
    guard let result = formatter.date(from: dateString) else {
        fatalError("Date string is not valid")
    }
    
    return result
}

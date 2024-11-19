//
//  TimetableWidgetAttributes.swift
//  TimetableManager
//
//  Created by Krzysztof on 18/11/2024.
//

import Foundation
import ActivityKit
import SwiftUI

struct TimetableWidgetAttributes: ActivityAttributes {
    public typealias TimerStatus = ContentState
    public struct ContentState: Codable, Hashable {
        
        var schedule: SimpleSchedule
        var nextSchedule: SimpleSchedule?
        
        var interval : ClosedRange<Date> {
           return schedule.start...schedule.end
        }
        
    }
    
}

struct SimpleSchedule: Codable, Hashable {
    
    var subjectName: String
    var start: Date
    var end: Date
    var type: String
    var room: String
    
}

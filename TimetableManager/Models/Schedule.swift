//
//  Schedule.swift
//  TimetableManager
//
//  Created by Krzysztof on 16/11/2024.
//

import Foundation
import SwiftData

@Model
class Schedule {
    
//    @Relationship(deleteRule: .cascade, inverse: \Subject.inSchedules)
    var subject: Subject?
    var type: String
    var weekday: String
    var teacher: String
    var room: String
    var start: Date
    var end: Date
    var name: String {
        return "\(subject?.name ?? "SUBJECT") \(type)"
    }
    var ignoreInView: Bool = false
    
    var nameOnList: String {
        return "\(self.weekday) \(self.start.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).minute()))"
    }
    
    var startTimeString: String {
        return self.start.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).minute())
    }
    
    var endTimeString: String {
        return self.end.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).minute())
    }
    
    var fullTimeString: String {
        return "\(self.start.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).minute())) - \(self.end.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).minute()))"
    }

    
    init(subject: Subject, type: String, weekday: String, teacher: String, room: String, start: Date, end: Date) {
        self.subject = subject
        self.type = type
        self.weekday = weekday
        self.teacher = teacher
        self.room = room
        self.start = start
        self.end = end
    }
    
    init(schedule: Schedule) {
        self.subject = schedule.subject
        self.type = schedule.type
        self.weekday = schedule.weekday
        self.teacher = schedule.teacher
        self.room = schedule.room
        self.start = schedule.start
        self.end = schedule.end
    }
    
    static let sampleData = [
        Schedule(subject: Subject.sampleData[0], type: "Lecture", weekday: "Monday", teacher: "Pan", room: "404", start: Date().addingTimeInterval(-60), end: Date().addingTimeInterval(60)),
        Schedule(subject: Subject.sampleData[0], type: "Lecture", weekday: "Monday", teacher: "Pan", room: "404", start: Date(), end: Date()),
    ]
    
    static func genericSchedule(subject: Subject, type: String) -> Schedule
    {
        return Schedule(subject: subject, type: type, weekday: "Tuesday", teacher: "Teacher", room: "404", start: Date(), end: Date())
    }
    
    
    
}

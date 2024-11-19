//
//  Subject.swift
//  TimetableManager
//
//  Created by Krzysztof on 15/11/2024.
//

import Foundation
import SwiftData

@Model
class Subject {
    var name: String
    var lecturer: String
    var types: [ActivityType]
    
    @Relationship(deleteRule: .cascade, inverse: \Schedule.subject)
    var inSchedules:[Schedule] = []
    
    init(name: String, lecturer: String, types: [String]? = nil) {
        self.name = name
        self.lecturer = lecturer
        self.types = types?.map { ActivityType(name: $0) } ?? [ActivityType(name: "Lecture"), ActivityType(name: "Exercise")]
    }
    
    init(subject: Subject) {
        self.name = subject.name
        self.lecturer = subject.lecturer
        self.types = subject.types
    }
    
    static let sampleData = [
        Subject(name: "KPABD", lecturer: "Paweł Rajba"),
        Subject(name: "MJ", lecturer: "Paweł Rychlikowski"),
        Subject(name: "ML", lecturer: "Marek Adamczyk"),
        Subject(name: "OWI", lecturer: "Pani Prawnik")
    ]
    
    static let genericSubject = Subject(name: "", lecturer: "", types: ["Lecture", "Exercise"])
}

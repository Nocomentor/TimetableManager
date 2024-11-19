//
//  ActivityType.swift
//  TimetableManager
//
//  Created by Krzysztof on 16/11/2024.
//

import Foundation
import SwiftData

@Model
class ActivityType {
    var id: UUID
    var name: String

    // Dodanie inicjalizatora
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

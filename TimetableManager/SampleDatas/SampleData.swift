//
//  SampleSubjects.swift
//  TimetableManager
//
//  Created by Krzysztof on 15/11/2024.
//

import Foundation
import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    var subject: Subject {
        Subject.sampleData.first!
    }
    
    var freeDay: FreeDay {
        FreeDay.sampleData.first!
    }
    
    var swapDate: SwapDate {
        SwapDate.sampleData.first!
    }
    
    var schedule: Schedule {
        Schedule.sampleData.first!
    }
    
    private init() {
        let schema = Schema([
            Subject.self,
            FreeDay.self,
            SwapDate.self,
            Schedule.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema , configurations: [modelConfiguration])
            
            insertSampleData()
            
            try context.save()
        } catch {
            fatalError("Could not create model container: \(error)")
        }
    }
    
    private func insertSampleData() {
        for subject in Subject.sampleData {
            context.insert(subject)
        }
        
        for freeDay in FreeDay.sampleData {
            context.insert(freeDay)
        }
        
        for swapDay in SwapDate.sampleData {
            context.insert(swapDay)
        }
        
        for schedule in Schedule.sampleData {
            context.insert(schedule)
        }
    }
}

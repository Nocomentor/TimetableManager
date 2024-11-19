//
//  ScheduleManager.swift
//  TimetableManager
//
//  Created by Krzysztof on 18/11/2024.
//

import Foundation
import SwiftData

@MainActor
class ScheduleManager {
    static let shared = ScheduleManager()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    init(){
        let schema = Schema([
            Subject.self,
            FreeDay.self,
            SwapDate.self,
            Schedule.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema)
        
        do {
            self.modelContainer = try ModelContainer(for: schema , configurations: [modelConfiguration])
//            try context.save()
        } catch {
            fatalError("Could not create model container: \(error)")
        }
    }
    
    
    func getSchedules() -> [Schedule] {
        let fetchDescriptor = FetchDescriptor<Schedule>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Błąd podczas pobierania harmonogramów: \(error)")
            return []
        }
    }
    
    func getNextSchedules(date: Date) -> [Schedule] {
        var schedules: [Schedule] = []
        let childContext = ModelContext(modelContainer)
            let fetchDescriptor = FetchDescriptor<Schedule>()
            do {
                schedules = try childContext.fetch(fetchDescriptor)
        } catch {
            print("Błąd podczas pobierania harmonogramów: \(error)")
            return []
        }
        
        schedules = schedules.filter({$0.ignoreInView == false})
        let weekday = weekDayFormDate(date: date)
        schedules = schedules.filter({$0.weekday == weekday})
        
        var copies: [Schedule] = []
        
        for schedule in schedules {
            copies.append(schedule)
        }
        
        for index in copies.indices {
            copies[index].start = sameDay(from: date, to: copies[index].start)
            copies[index].end = sameDay(from: date, to: copies[index].end)
        }

        copies = copies.filter({$0.end >= date})
        copies = copies.sorted { $0.start < $1.start }
           
       return copies
    }
    
    private func sameDay(from: Date, to: Date) -> Date {
        let kalendarz = Calendar.current
        
        // Wyodrębnij komponenty dnia, miesiąca i roku z data1
        let komponentyData1 = kalendarz.dateComponents([.year, .month, .day], from: from)
        
        // Wyodrębnij komponenty godziny i minuty z data2
        let komponentyData2 = kalendarz.dateComponents([.hour, .minute], from: to)
        
        // Utwórz nowe komponenty, łącząc powyższe
        var noweKomponenty = DateComponents()
        noweKomponenty.year = komponentyData1.year
        noweKomponenty.month = komponentyData1.month
        noweKomponenty.day = komponentyData1.day
        noweKomponenty.hour = komponentyData2.hour
        noweKomponenty.minute = komponentyData2.minute
        
        // Utwórz nową datę z połączonych komponentów
        return kalendarz.date(from: noweKomponenty) ?? Date()
    }
}

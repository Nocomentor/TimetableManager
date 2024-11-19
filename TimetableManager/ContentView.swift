//
//  ContentView.swift
//  TimetableManager
//
//  Created by Krzysztof on 15/11/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            Tab("Now", systemImage: "eye.circle") {
                NowView(nextSchedules: [], schedule: SampleData.shared.schedule, next: SampleData.shared.schedule)
            }
            
            Tab("Today", systemImage: "text.rectangle.page") {
                DayView()
            }
            
            Tab("Timetable", systemImage: "calendar.badge.clock") {
                TimetableView()
            }
            
            Tab("Subjects", systemImage: "list.clipboard") {
                SubjectsList()
            }
            
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}


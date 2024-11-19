//
//  TimetableView.swift
//  TimetableManager
//
//  Created by Krzysztof on 17/11/2024.
//

import SwiftUI
import SwiftData

struct TimetableView: View {
    
    @Query(sort: [SortDescriptor(\Schedule.weekday), SortDescriptor(\Schedule.start)]) private var schedules: [Schedule]

    @Environment(\.modelContext) private var context
    
    var body: some View {
        
        var groupedSchedules: [String: [Schedule]] {
                Dictionary(grouping: schedules, by: { $0.weekday })
            }
        
        let weekDaysOrder = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
            
        
        NavigationView {
            List {
                ForEach(weekDaysOrder, id: \.self) { day in
                    if let daySchedules = groupedSchedules[day] {
                        Section(header: Text(day).font(.title2).bold()) {
                            ForEach(daySchedules) { schedule in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(schedule.name)
                                            .font(.headline)
                                        Text("Room: \(schedule.room)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text(schedule.fullTimeString)
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Timetable")
        }
    }
}

#Preview {
    TimetableView()
        .modelContainer(SampleData.shared.modelContainer)
}

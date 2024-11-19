//
//  ScheduleDetails.swift
//  TimetableManager
//
//  Created by Krzysztof on 16/11/2024.
//

import SwiftUI

struct ScheduleDetails: View {
    @Bindable var schedule: Schedule
    
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text(schedule.name)){
                    Picker("Weekday", selection: $schedule.weekday) {
                        ForEach(days, id: \.self) { day in
                            Text(day)
                                .tag(day)
                        }
                    }
                    
                    TextField("Teacher", text: $schedule.teacher)
                        .autocorrectionDisabled()
                    
                    TextField("Room", text: $schedule.room)
                        .autocorrectionDisabled()
                    
                    DatePicker("Start", selection: $schedule.start, displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                        .onChange(of: schedule.start){
                            if(schedule.start > schedule.end){
                                schedule.end = schedule.start
                            }
                        }
                    
                    DatePicker("End", selection: $schedule.end, displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                        .onChange(of: schedule.end){
                            if(schedule.start > schedule.end){
                                schedule.start = schedule.end
                            }
                        }
                    
                    Toggle("Ignore in timetable", isOn: $schedule.ignoreInView)
                        
                }
            }
            .navigationTitle(schedule.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ScheduleDetails(schedule: SampleData.shared.schedule)
}

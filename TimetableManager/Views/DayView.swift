//
//  DayView.swift
//  TimetableManager
//
//  Created by Krzysztof on 17/11/2024.
//

import SwiftUI
import SwiftData

struct DayView: View {
    
    @Query(filter: #Predicate<Schedule> { $0.ignoreInView == false }) private var schedules: [Schedule]
    @Query private var freeDays: [FreeDay]
    @Query private var swapDates: [SwapDate]
    @Environment(\.modelContext) private var context
    
    @State private var displayedSchedules: [Schedule] = []
    @State private var selectedDate: Date = Date()
    
    @State private var nowTopPadding: CGFloat = 0
    @State private var navTitle: String = dayDescription(for: Date())
    
    @State private var freeDay: FreeDay?
    @State private var swapDate: SwapDate?
    
    
    var body: some View {
        NavigationView{
            ZStack {
                ScrollView {
                    
                    VStack() {
                        
                        if(freeDay != nil){
                            VStack {
                                Text("Free day")
                                    .font(.title2)
                                Text(freeDay?.title ?? "")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                            }
                            .padding()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.purple)
                                    .opacity(0.8)
                                    .brightness(-0.4)
                            }
                            .padding()
                            .padding(.horizontal, 60)
                            
                        }
                        
                        if(swapDate != nil){
                            VStack {
                                Text("Date swapped")
                                    .font(.title2)
                                Text("\(weekDayFormDate(date: swapDate?.date ?? Date())) ⟼ \(weekDayFormDate(date: swapDate?.swapDate ?? Date()))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                            }
                            .padding()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.orange)
                                    .opacity(0.8)
                                    .brightness(-0.4)
                            }
                            .padding()
                            .padding(.horizontal, 60)
                            
                        }
                        
                        
                        ZStack(alignment: .top) {
                            
                            VStack(spacing: 0) {
                                
                                Divider()
                                
                                ForEach(6..<22, id: \.self) { hour in
                                    HStack {
                                        
                                        VStack {
                                            Spacer()
                                            Text("\(hour):00")
                                        }
                                        
                                        Spacer()
                                    }
                                    .frame(height: 59.7)
                                    Divider()
                                }
                            }
                            ForEach(displayedSchedules) { schedule in
                                ExtractedView(schedule: schedule)
                                
                            }
                            
                            if(navTitle == "Today"){
                                VStack(spacing: 1) {
                                    
                                    HStack{
                                        Text("NOW")
                                            .foregroundStyle(.red)
                                            .fontWeight(.heavy)
                                        Spacer()
                                    }
                                    
                                    Rectangle()
                                        .frame(height: 3)
                                        .foregroundColor(.red)
                                    
                                }
                                .padding(.horizontal, 0)
                                .padding(.top, nowTopPadding)
                                .shadow(color: .gray, radius: 2, x: 0, y: 0)
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle(navTitle)
                .onAppear {
                    selectedDate = Date()
                    filterSchedules(for: selectedDate)
                    
                    let now = Date()
                    
                    let calendar = Calendar.current
                    let startOfDay = calendar.startOfDay(for: now)
                    let sixAM = calendar.date(bySettingHour: 5, minute: 0, second: 0, of: startOfDay)!

                    let difference = calendar.dateComponents([.minute], from: sixAM, to: now)
                    
                    nowTopPadding = CGFloat(max(0, difference.minute ?? 0)) - 20
                }
                .padding(.bottom, 80)
                VStack {
                    
                    Spacer()
                    
                    HStack {
                        HStack {
                            Spacer()
                            
                            Button(action: {selectedDate = selectedDate.addingTimeInterval(-1 * 24 * 60 * 60)}){
                                
                                Image(systemName: "arrow.left.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                            
                            DatePicker("For: ", selection: $selectedDate, displayedComponents: .date)
                                .labelsHidden()
                                .onChange(of: selectedDate){
                                    navTitle = dayDescription(for: selectedDate)
                                    filterSchedules(for: selectedDate)
                                }
                            
                            Button(action: {selectedDate = selectedDate.addingTimeInterval(24 * 60 * 60)}){
                                Image(systemName: "arrow.right.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                            
                            Spacer()
                        }
                        .padding(20)
                    }
                }
            }
        }
        
    }
    
    func filterSchedules(for date: Date) {
        withAnimation{
            displayedSchedules = []
            freeDay = nil
            swapDate = nil
            
            let free = freeDays.filter{$0.isInRange(date: date)}
            freeDay = free.first ?? nil
            
            if(freeDay != nil){
                return
            }
            
            let swap = swapDates.filter{$0.isDate(date: date)}
            swapDate = swap.first ?? nil
            
            let weekday = weekDayFormDate(date: swapDate?.swapDate ?? date)
            displayedSchedules = schedules.filter { $0.weekday == weekday }
        }
    }

}

#Preview {
    DayView()
        .modelContainer(SampleData.shared.modelContainer)
}

func dayDescription(for date: Date) -> String {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let inputDate = calendar.startOfDay(for: date)
    
    if inputDate == today {
        return "Today"
    } else if inputDate == calendar.date(byAdding: .day, value: -1, to: today) {
        return "Yesterday"
    } else if inputDate == calendar.date(byAdding: .day, value: 1, to: today) {
        return "Tomorrow"
    } else {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter.string(from: date)
    }
}


struct ExtractedView: View {
    
    let schedule: Schedule
    
    var startMinutesDifference: Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: schedule.start)
        let sixAM = calendar.date(bySettingHour: 5, minute: 0, second: 0, of: startOfDay)!

        let difference = calendar.dateComponents([.minute], from: sixAM, to: schedule.start)
        return max(0, difference.minute ?? 0)
    }
    
    var  paddingTop: CGFloat {
        return CGFloat(startMinutesDifference)
    }
    
    var height: CGFloat {
        let calendar = Calendar.current

        let components1 = calendar.dateComponents([.hour, .minute], from: schedule.start)
        let components2 = calendar.dateComponents([.hour, .minute], from: schedule.end)

        let timeOnly1 = calendar.date(bySettingHour: components1.hour ?? 0, minute: components1.minute ?? 0, second: 0, of: Date())!
        let timeOnly2 = calendar.date(bySettingHour: components2.hour ?? 0, minute: components2.minute ?? 0, second: 0, of: Date())!

        let difference = calendar.dateComponents([.minute], from: timeOnly1, to: timeOnly2)
        return CGFloat(abs(difference.minute ?? 0))
    }
    
    var body: some View {
        HStack{
            Spacer()
            VStack {
                Text(schedule.name)
                Text("Room: \(schedule.room)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack{
                Text(schedule.startTimeString)
                Spacer()
                Text(schedule.endTimeString)
                    
            }
            .padding()
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .foregroundStyle(.white)
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.tint)
//                .opacity(0.8)
//                .brightness(-0.4)
        }
        .padding(.leading, 50)
        .padding(.top, paddingTop)
    }
}

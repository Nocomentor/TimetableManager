//
//  NowView.swift
//  TimetableManager
//
//  Created by Krzysztof on 18/11/2024.
//

import SwiftUI

struct NowView: View {
    @State var nextSchedules: [Schedule]
    @State var schedule: Schedule
    @State var next: Schedule?
    
    var interval: ClosedRange<Date> {
        let start = schedule.start
        return start...schedule.end
    }
    
    var body: some View {
        VStack{
            VStack{
                HStack {
                    Image(systemName: "book.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .padding(10)
                    
                    Spacer()
                    if(!schedule.type.isEmpty){
                        Text("\(schedule.type) in \(schedule.room)")
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading){
                        Text("Next: \(next?.subject?.name ?? "-")")
                        Text(next?.type ?? "-")
                        Text("Class: \(next?.room ?? "-")")
                    }
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .padding(10)
                }
                
                VStack{
                    if(schedule.subject?.name == "End"){
                        HStack{
                            Text("End of activities today")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                    } else {
                        ProgressView(
                            timerInterval: interval,
                            label: {
                                HStack(alignment: .bottom){
                                    Text(schedule.subject?.name ?? "x")
                                        .font(.title2)
                                        .bold()
                                    Text(schedule.end, style: .timer)
                                }
                            },
                            currentValueLabel: { EmptyView() })
                        .padding(10)
                    }
                }
            }
            .padding()
            
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(.black)
        }
        .padding()
        .onAppear(){
            UpdateData()
        }
        
        // TODO: make it better 
        
        Button("Add Live Activity"){
            let scheduleLive = SimpleSchedule(subjectName: schedule.subject?.name ?? "x", start: schedule.start, end: schedule.end, type: schedule.type, room: schedule.room)
            
            var nextLive: SimpleSchedule?
            
            if(next != nil){
                nextLive = SimpleSchedule(subjectName: next?.subject?.name ?? "x", start: next?.start ?? Date(), end: next?.end ?? Date(), type: next?.type ?? "x", room: next?.room ?? "x")
            } else {
                nextLive = nil
            }
            
            LiveActivityManager.shared.startActivity(state: TimetableWidgetAttributes.ContentState(schedule: scheduleLive, nextSchedule: nextLive))
        }
        .buttonStyle(.borderedProminent)
        
        Button("Edit Live Activity"){
            let scheduleLive = SimpleSchedule(subjectName: "DZIAŁA", start: schedule.start, end: schedule.end, type: schedule.type, room: schedule.room)
            
            var nextLive: SimpleSchedule?
            
            if(next != nil){
                nextLive = SimpleSchedule(subjectName: "DZIAŁA!", start: next?.start ?? Date(), end: next?.end ?? Date(), type: next?.type ?? "x", room: next?.room ?? "x")
            } else {
                nextLive = nil
            }
            
            LiveActivityManager.shared.updateActivity(state: TimetableWidgetAttributes.ContentState(schedule: scheduleLive, nextSchedule: nextLive))
        }
        .buttonStyle(.borderedProminent)
    }
    
    private func UpdateData(){
        let now = Date()//.addingTimeInterval(60 * 60 * 5)
        
        next = nil
        
        nextSchedules = ScheduleManager.shared.getNextSchedules(date: now)
        
        let endSch = Schedule(subject: Subject(name: "End", lecturer: ""), type: "", weekday: "", teacher: "", room: "", start: Date(), end: Date())
        let breakSch = Schedule(subject: Subject(name: "Break", lecturer: ""), type: "", weekday: "", teacher: "", room: "", start: now, end: nextSchedules.first?.start ?? Date())
        
        if(nextSchedules.isEmpty){
            schedule = endSch
            return
        }

        
        if(nextSchedules.first?.start ?? Date() >= now ){
            next = nextSchedules.first
            schedule = breakSch
            NextUpdateAt(date: next?.start ?? Date().addingTimeInterval(-1 * 60))
            return
        }
        
        if(nextSchedules.count > 1){
            next = nextSchedules[1]
        }
        
        schedule = nextSchedules.first ?? endSch
        NextUpdateAt(date: schedule.end)
    }
    
    private func NextUpdateAt(date: Date){
        let targetDate = date
        let currentDate = Date()
        let timeInterval = targetDate.timeIntervalSince(currentDate)

        if timeInterval > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                UpdateData()
            }
        } else {
            print("update w przeszlosci")
        }
    }
}
 
struct TextTimer: View {
    // Return the largest width string for a time interval
    private static func maxStringFor(_ time: TimeInterval) -> String {
        if time < 600 { // 9:99
            return "0:00"
        }
        
        if time < 3600 { // 59:59
            return "00:00"
        }
        
        if time < 36000 { // 9:59:59
            return "0:00:00"
        }
        
        return "00:00:00"// 99:59:59
    }
    init(_ date: Date, font: UIFont, width: CGFloat? = nil) {
        self.date = date
        self.font = font
        if let width {
            self.width = width
        } else {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let time = date.timeIntervalSinceNow
            let maxString = Self.maxStringFor(time)
            self.width = (maxString as NSString).size(withAttributes: fontAttributes).width
        }
    }
    
    let date: Date
    let font: UIFont
    let width: CGFloat
    var body: some View {
        Text(timerInterval: Date.now...date)
            .font(Font(font))
            .frame(width: width > 0 ? width : nil)
            .minimumScaleFactor(0.5)
            .lineLimit(1)
    }
}


#Preview {
    NowView(nextSchedules: [], schedule: SampleData.shared.schedule, next: SampleData.shared.schedule)
}

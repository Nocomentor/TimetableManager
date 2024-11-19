//
//  TimetableWidget.swift
//  TimetableWidget
//
//  Created by Krzysztof on 18/11/2024.
//

import WidgetKit
import SwiftUI


struct TimetableWidgetEntryView : View {
    let context: ActivityViewContext<TimetableWidgetAttributes>
    
    var body: some View {
        VStack{
            HStack {
                Image(systemName: "book.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .padding(10)
                
                Spacer()
                if(!context.state.schedule.type.isEmpty){
                    Text("\(context.state.schedule.type) in \(context.state.schedule.room)")
                }
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text("Next: \(context.state.nextSchedule?.subjectName ?? "-")")
                    Text(context.state.nextSchedule?.type ?? "-")
                    Text("Class: \(context.state.nextSchedule?.room ?? "-")")
                }
                .foregroundStyle(.secondary)
                .font(.caption)
                .padding(10)
            }
            
            VStack{
                if(context.state.schedule.subjectName == "End"){
                    HStack{
                        Text("End of activities today")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                } else {
                    ProgressView(
                        timerInterval: context.state.interval,
                        label: {
                            HStack(alignment: .bottom){
                                Text(context.state.schedule.subjectName)
                                    .font(.title2)
                                    .bold()
                                Text(context.state.schedule.end, style: .timer)
                                //                            TextTimer(schedule.end, font: .systemFont(ofSize: 28, weight: UIFont.Weight.regular))
                            }
                        },
                        currentValueLabel: { EmptyView() })
                    .padding(10)
                }
            }
        }
        .padding()
        .background(.black)
        .foregroundStyle(.white)
    }
    
}

struct TimetableWidget: Widget {
    let kind: String = "TimetableWidget"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimetableWidgetAttributes.self) { context in
            TimetableWidgetEntryView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
               // Konfiguracja widoku po rozszerzeniu Dynamic Island
                DynamicIslandExpandedRegion(.center) {
                    if(!context.state.schedule.type.isEmpty){
                        VStack(alignment: .center){
                            Spacer()
                            Text("\(context.state.schedule.type) in \(context.state.schedule.room)")
                            Spacer()
                        }
                    }
                }
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "book.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .padding(10)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .leading){
                        Text("Next: \(context.state.nextSchedule?.subjectName ?? "-")")
                        Text(context.state.nextSchedule?.type ?? "-")
                        Text("Class: \(context.state.nextSchedule?.room ?? "-")")
                    }
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .padding(10)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    if(context.state.schedule.subjectName == "End"){
                        HStack{
                            Text("End of activities today")
                                .font(.title2)
                                .bold()
                                .padding(10)
                        }
                    } else {
                        ProgressView(
                            timerInterval: context.state.interval,
                            label: {
                                HStack(alignment: .bottom){
                                    Text(context.state.schedule.subjectName)
                                        .font(.title2)
                                        .bold()
                                    //                                Text(context.state.schedule.end, style: .timer)
                                    TextTimer(context.state.schedule.end, font: .systemFont(ofSize: 28, weight: UIFont.Weight.regular))
                                }
                            },
                            currentValueLabel: { EmptyView() })
                        .padding(10)
                    }
                            
                }
                } compactLeading: {
//                    Text(context.state.schedule.end, style: .timer)
                    TextTimer(context.state.schedule.end, font: .systemFont(ofSize: 12, weight: UIFont.Weight.regular))
                        .padding(.leading, 5)
                } compactTrailing: {
                    ProgressView(timerInterval: context.state.interval, label: { EmptyView() },currentValueLabel: { EmptyView() })
                        .padding(.horizontal, 10)
                        .progressViewStyle(.circular)
                        .frame(width: 40, height: 40)
                } minimal: {
                    ProgressView(timerInterval: context.state.interval, label: { EmptyView() },currentValueLabel: { EmptyView() })
                        .padding(.horizontal, 10)
                        .progressViewStyle(.circular)
                        .frame(width: 40, height: 40)
                }
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

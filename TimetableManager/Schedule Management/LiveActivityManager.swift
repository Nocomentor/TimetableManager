//
//  LiveActivityManager.swift
//  TimetableManager
//
//  Created by Krzysztof on 18/11/2024.
//

import Foundation
import ActivityKit

class LiveActivityManager {
    static let shared = LiveActivityManager()
    private var activity: Activity<TimetableWidgetAttributes>?
    
    init(){
        
    }
    
    deinit {
        stopActivity()
    }
    
    func startActivity(state: TimetableWidgetAttributes.ContentState){
        
        if(activity != nil) {
            return;
        }

        let content = ActivityContent(state: state, staleDate: nil)
        let attributes = TimetableWidgetAttributes()
        
        do {
            activity = try Activity<TimetableWidgetAttributes>.request(attributes: attributes, content: content, pushType: nil)
        } catch {
            print("Błąd podczas tworzenia aktywności: \(error.localizedDescription)")
        }
    }
    
    func updateActivity(state: TimetableWidgetAttributes.ContentState){
        
        if(activity == nil) {
            return;
        }

        let content = ActivityContent(state: state, staleDate: nil)
        
        Task {
            await activity?.update(content)
        }
    }
    
    func stopActivity() {
        
        if(activity == nil) {
            return;
        }
        
        let stopSchedule = SimpleSchedule(subjectName: "", start: Date(), end: Date(), type: "", room: "")
        let state = TimetableWidgetAttributes.ContentState(schedule: stopSchedule, nextSchedule: nil)
        
//        let state = TimetableWidgetAttributes.ContentState()
        let content = ActivityContent(state: state, staleDate: nil)

        Task {
            await activity?.end(content, dismissalPolicy: .immediate)
        }
        
        activity = nil;
    }
    
    static func forceStopAllActivities(){
        Task
        {
            for activity in Activity<TimetableWidgetAttributes>.activities
            {
                print("Ending Live Activity: \(activity.id)")
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }
    
}



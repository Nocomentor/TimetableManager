//
//  TimetableManagerApp.swift
//  TimetableManager
//
//  Created by Krzysztof on 15/11/2024.
//

import SwiftUI

@main
struct TimetableManagerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Subject.self, FreeDay.self, SwapDate.self, Schedule.self])
        }
    }
}

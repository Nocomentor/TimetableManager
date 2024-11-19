//
//  AppDelegate.swift
//  TimetableManager
//
//  Created by Krzysztof on 19/11/2024.
//

import Foundation
import UIKit
import ActivityKit


class AppDelegate: UIResponder, UIApplicationDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        print("Wylaczanie app delegate")
        Task {
            LiveActivityManager.shared.stopActivity()
        }
    }
}


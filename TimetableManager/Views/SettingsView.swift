//
//  SettingsView.swift
//  TimetableManager
//
//  Created by Krzysztof on 16/11/2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationSplitView{
            List{
                NavigationLink("Free days") {
                    FreeDaysList()
                }
                NavigationLink("Swap dates") {
                    SwapDatesList()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            
        } detail: {
            Text("Settings")
        }
    }
}

#Preview {
    SettingsView()
}

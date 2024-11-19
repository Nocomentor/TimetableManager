//
//  SwapDateDetails.swift
//  TimetableManager
//
//  Created by Krzysztof on 16/11/2024.
//

import SwiftUI

struct SwapDateDetails: View {
    @Bindable var swapDate: SwapDate
    var body: some View {
        Form {
            DatePicker("Swap date", selection: $swapDate.date, displayedComponents: .date)
            DatePicker("Swap from", selection: $swapDate.swapDate, displayedComponents: .date)
            Section(header: HStack{
                Spacer()
                Text("\(weekDayFormDate(date: swapDate.date)) ⟼ \(weekDayFormDate(date: swapDate.swapDate))")
                Spacer()
            }) {}
            
        }
        .navigationTitle("Swap date")
        .navigationBarTitleDisplayMode(.inline)
    }
}

func weekDayFormDate(date: Date) -> String{

    let dayFormatter = DateFormatter()
    dayFormatter.dateFormat = "EEEE"
    dayFormatter.locale = Locale(identifier: "en_EN")
    let formattedDay = dayFormatter.string(from: date)

    return formattedDay
}

#Preview {
    SwapDateDetails(swapDate: SampleData.shared.swapDate)
}

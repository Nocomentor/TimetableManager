//
//  FreeDayDetails.swift
//  TimetableManager
//
//  Created by Krzysztof on 16/11/2024.
//

import SwiftUI

struct FreeDayDetails: View {
    @Bindable var freeDay: FreeDay
    
    @State var oneDay: Bool
    @State var toggleState: Bool
    @State var pickedEndDate: Date
        
    init(freeDay: FreeDay) {
        self.freeDay = freeDay
        _pickedEndDate = State(initialValue: freeDay.endDate)
        _oneDay = State(initialValue: freeDay.endDate == freeDay.startDate)
        _toggleState = State(initialValue: freeDay.endDate == freeDay.startDate)
    }
    
    var body: some View {
        Form{
            
            TextField("Title", text: $freeDay.title)
                .autocorrectionDisabled()
            
            DatePicker(oneDay ? "Date" : "Start Date", selection: $freeDay.startDate, displayedComponents: .date)
                .onChange(of: freeDay.startDate) {
                    if(freeDay.startDate > pickedEndDate){
                        pickedEndDate = freeDay.startDate 
                    }
                }
            
            if !oneDay {
                DatePicker("End Date", selection: $pickedEndDate, displayedComponents: .date)
                    .onChange(of: pickedEndDate) {
                        freeDay.endDate = pickedEndDate
                        
                        if(freeDay.startDate > pickedEndDate){
                            freeDay.startDate = pickedEndDate
                        }
                    }

            }
            
            Toggle("One day free", isOn: $toggleState)
                .onChange(of: toggleState){
                    withAnimation{
                        oneDay = toggleState
                        if(!oneDay){
                            freeDay.endDate = pickedEndDate
                        } else {
                            freeDay.endDate = freeDay.startDate
                        }
                    }
                }
        }
        .navigationTitle("Free day")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FreeDayDetails(freeDay: SampleData.shared.freeDay)
}

//
//  FreeDaysList.swift
//  TimetableManager
//
//  Created by Krzysztof on 15/11/2024.
//

import SwiftUI
import SwiftData

struct FreeDaysList: View {
    @Query(sort: \FreeDay.startDate) private var freeDays: [FreeDay]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(freeDays){freeDay in
                    NavigationLink(freeDay.title) {
                        FreeDayDetails(freeDay: freeDay)
                        
                    }
                }
                .onDelete(perform: deleteFreeDays(indexes:))
            }
            .navigationTitle("Free days")
            .toolbar {
                ToolbarItem {
                    Button("Add free day", systemImage: "plus", action: addFreeDay)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }

    }
    
    private func addFreeDay() {
        context.insert(FreeDay(freeDay: .genericFreeDay))
    }
    
    private func deleteFreeDays(indexes: IndexSet) {
        for index in indexes {
            context.delete(freeDays[index])
        }
    }
}

#Preview {
    FreeDaysList()
        .modelContainer(SampleData.shared.modelContainer)
}

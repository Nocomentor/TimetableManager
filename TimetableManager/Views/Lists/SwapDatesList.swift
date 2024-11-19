//
//  SwapDatesList.swift
//  TimetableManager
//
//  Created by Krzysztof on 15/11/2024.
//

import SwiftUI
import SwiftData

struct SwapDatesList: View {
    @Query(sort: \SwapDate.date) private var swapDates: [SwapDate]
    @Environment(\.modelContext) private var context
    
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(swapDates){swapDate in
                    
                    NavigationLink(swapDateToTitle(swapDate: swapDate)) {
                        SwapDateDetails(swapDate: swapDate)
                    }
                }
                .onDelete(perform: deleteSwapDates(indexes:))
            }
            .navigationTitle("Swap dates")
            .toolbar {
                ToolbarItem{
                    Button("Add swap date", systemImage: "plus", action: addSwapDate)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    private func addSwapDate() {
        context.insert(SwapDate(swapDate: .genericSwapDate))
    }
    
    private func deleteSwapDates(indexes: IndexSet) {
        for index in indexes {
            context.delete(swapDates[index])
        }
    }
}

func swapDateToTitle(swapDate: SwapDate) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    dateFormatter.locale = Locale(identifier: "pl_PL")

    let dayFormatter = DateFormatter()
    dayFormatter.dateFormat = "EEEE"
    dayFormatter.locale = Locale(identifier: "en_EN")

    let formattedDate = dateFormatter.string(from: swapDate.date)
    let formattedDay = dayFormatter.string(from: swapDate.swapDate)

    return "\(formattedDate) ⟼ \(formattedDay)"
}

#Preview {
    SwapDatesList()
        .modelContainer(SampleData.shared.modelContainer)
}

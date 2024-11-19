//
//  SubjectSchedulesByTypeList.swift
//  TimetableManager
//
//  Created by Krzysztof on 16/11/2024.
//

import SwiftUI

struct SubjectSchedulesByTypeList: View {
    @Bindable var subject: Subject
    @Bindable var type: ActivityType
    @Environment(\.modelContext) private var context
    var body: some View {
        Section(header:
            HStack{
            Text("\(type.name):")
                Spacer()
            
            Button("", systemImage: "plus"){
                addSchedule()
            }
            EditButton()
            }
        ) {
            
                List{
//                    ForEach(subject.inSchedules.filter { $0.type == type.name }, id: \.self) { schedule in
                    ForEach(subject.inSchedules){ schedule in
                        if(schedule.type == type.name){
                            NavigationLink(schedule.nameOnList) {
                                ScheduleDetails(schedule: schedule)
                                
                            }
                        }
                    }
                    .onDelete(perform: deleteSchedule)
                }
            
        }
    }
    
    private func addSchedule() {
        let newSchedule = Schedule(schedule: .genericSchedule(subject: subject, type: type.name))
        context.insert(newSchedule)
        subject.inSchedules.append(newSchedule)
    }
    
    private func deleteSchedule(at offsets: IndexSet) {
        for offset in offsets {
            let chToDel = subject.inSchedules[offset]
            subject.inSchedules.remove(at: offset)
            context.delete(chToDel)
        }
    }

}

#Preview {
    NavigationView{
        Form{
            SubjectSchedulesByTypeList(subject: SampleData.shared.subject, type: ActivityType(name: "Lecture"))
        }
    }
}

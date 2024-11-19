//
//  SubjectDetails.swift
//  TimetableManager
//
//  Created by Krzysztof on 15/11/2024.
//

import SwiftUI

struct SubjectDetails: View {
    @Bindable var subject: Subject
    
    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    init(subject: Subject, isNew : Bool = false){
        self.subject = subject
        self.isNew = isNew
    }
    
    @State var isExpanded: Bool = true
    @State private var selectedTime = Date()
    
    var body: some View {
        Form {
            Section(header: Text("Generals")) {
                TextField("Name", text: $subject.name)
                    .autocorrectionDisabled()
                
                TextField("Lecturer", text: $subject.lecturer)
                    .autocorrectionDisabled()
            }
            
            Section(header:
                HStack{
                    Text("Activities types")
                    Spacer()
                
                    Button("", systemImage: "plus", action: addType)
                    EditButton()
                }
            ) {
                List {
                    ForEach($subject.types) { $type in
                       TextField("Type", text: $type.name)
                           .autocorrectionDisabled()
                   }
                    .onDelete(perform: removeTypes)
                }
            }
            ForEach($subject.types) { $type in
                SubjectSchedulesByTypeList(subject: subject, type: type)
           }
        }
        .navigationTitle(isNew ? "New Subject" : subject.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if(isNew){
                ToolbarItem(placement: .confirmationAction){
                    Button("Save"){
                        dismiss()
                    }
                    .disabled(subject.name.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){
                        context.delete(subject)
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addType() {
        withAnimation{
            subject.types.append(ActivityType(name: ""))
        }
    }
    
    private func removeTypes(at offsets: IndexSet) {
        subject.types.remove(atOffsets: offsets)
    }
}

#Preview {
    NavigationStack {
        SubjectDetails(subject: SampleData.shared.subject)
    }
}

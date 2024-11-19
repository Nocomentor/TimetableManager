//
//  SubjectsList.swift
//  TimetableManager
//
//  Created by Krzysztof on 15/11/2024.
//

import SwiftUI
import SwiftData

struct SubjectsList: View {
    @Query(sort: \Subject.name) private var subjects: [Subject]
    @Environment(\.modelContext) private var context
    
    @State private var newSubject: Subject?
    
    var body: some View {
        NavigationSplitView{
            List{
                ForEach(subjects){subject in
                    NavigationLink(subject.name) {
                        SubjectDetails(subject: subject)
                    
                    }
                }
                .onDelete(perform: deleteSubjects(indexes:))
            }
            .onAppear {
                
                do {
                    try context.save()
                } catch {
                    print("Błąd podczas pobierania przedmiotów: \(error)")
                }
            }
            .navigationTitle("Subjects")
            .toolbar {
                ToolbarItem {
                    Button("Add subject", systemImage: "plus", action: addSubject)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .sheet(item: $newSubject) { subject in
                NavigationStack{
                    SubjectDetails(subject: subject, isNew: true)
                }
                .interactiveDismissDisabled()
            }
        } detail: {
            Text("Select a subject")
                .navigationTitle("Subject")
                .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    private func addSubject() {
        let newSubject = Subject(subject: .genericSubject)
        context.insert(newSubject)
        self.newSubject = newSubject
    }
    
    private func deleteSubjects(indexes: IndexSet) {
        for index in indexes {
            context.delete(subjects[index])
        }
    }
}

#Preview {
    SubjectsList()
        .modelContainer(SampleData.shared.modelContainer)
}

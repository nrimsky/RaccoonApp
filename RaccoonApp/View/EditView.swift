//
//  EditView.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 15/07/2022.
//

import SwiftUI

struct EditView: View {
    
    @ObservedObject var habit: Habit
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        let startDate = Binding(
            get: { Helpers.stringToDate(habit.startDay) },
            set: { habit.startDay = Helpers.dateToString($0) }
        )
        let endDate = Binding(
            get: { Helpers.stringToDate(habit.endDay) },
            set: { habit.endDay = Helpers.dateToString($0) }
        )
        return Form {
            Section(header: Text("Habit")) {
                TextField("Title", text: $habit.title)
                TextField("Description", text: $habit.description)
            }
            Section(header: Text("Dates")) {
                DatePicker("Start Date", selection: startDate, in: ...endDate.wrappedValue, displayedComponents: [.date])
                DatePicker("End Date", selection: endDate, in: startDate.wrappedValue...,
                           displayedComponents: [.date])
            }
            Section() {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("Done")
                }
                Button(action: {
                    appState.delete(habit: habit)
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("Delete").foregroundColor(.red)
                }
            }
        }.navigationTitle("Edit")
        .onAppear {
            habit.isEditing = true
        }
        .onDisappear {
            try? appState.persist()
            habit.isEditing = false
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(habit: Helpers.mockHabits()[0])
    }
}

//
//  AddNewView.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 15/07/2022.
//

import SwiftUI

struct AddNewView: View {
    
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State var habit: Habit = Habit()
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    
    var body: some View {
        Form {
            Section(header: Text("Habit")) {
                TextField("Title", text: $habit.title)
                TextField("Description", text: $habit.description)
            }
            Section(header: Text("Dates")) {
                DatePicker("Start Date", selection: $startDate, in: ...endDate, displayedComponents: [.date])
                DatePicker("End Date", selection: $endDate, in: startDate...,
                           displayedComponents: [.date])
            }
            Section() {
                Button(action: {
                    habit.startDay = Helpers.dateToString(startDate)
                    habit.endDay = Helpers.dateToString(endDate)
                    appState.add(habit: habit)
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("Save")
                }
            }
        }.navigationTitle("Add a new habit")
    }
}

struct AddNewView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewView().environmentObject(AppState())
    }
}

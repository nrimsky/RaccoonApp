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
    @State var noEndDate = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Form {
                Section(header: Text("Habit")) {
                    TextField("Title", text: $habit.title)
                    TextField("Description", text: $habit.description)
                }
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, in: ...endDate, displayedComponents: [.date])
                    if noEndDate {
                        Text("No end date")
                        Button("Add End Date") {
                            noEndDate = false
                        }
                    } else {
                        DatePicker("End Date", selection: $endDate, in: startDate...,
                                   displayedComponents: [.date])
                        Button("No End Date") {
                            noEndDate = true
                        }
                    }
                }
                Section() {
                    Button("Save"){
                        habit.startDay = Helpers.dateToString(startDate)
                        if noEndDate {
                            habit.endDay = ""
                        } else {
                            habit.endDay = Helpers.dateToString(endDate)
                        }
                        appState.add(habit: habit)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            Image("StandingRaccoon2")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
        .navigationTitle("Add a new habit")
        .onAppear {
            startDate = appState.viewingDate
            endDate = appState.viewingDate
        }
    }
}

struct AddNewView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewView().environmentObject(AppState())
    }
}

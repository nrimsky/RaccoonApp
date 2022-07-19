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
                    TextField("Something you want to do every day", text: $habit.title).font(Font.custom(Helpers.fontName, size: UIFont.labelFontSize))
                }
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, in: ...endDate, displayedComponents: [.date])
                    if noEndDate {
                        Text("No end date")
                        AppButton(type: .normal, onPress: {noEndDate = false}, text: "Add End Date")
                    } else {
                        DatePicker("End Date", selection: $endDate, in: startDate...,
                                   displayedComponents: [.date])
                        AppButton(type: .normal, onPress: {noEndDate = true}, text: "No End Date")
                    }
                }
                Section() {
                    AppButton(type: .normal, onPress: {
                        habit.startDay = Helpers.dateToString(startDate)
                        if noEndDate {
                            habit.endDay = ""
                        } else {
                            habit.endDay = Helpers.dateToString(endDate)
                        }
                        appState.add(habit: habit)
                        presentationMode.wrappedValue.dismiss()
                    }, text: "Save")
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

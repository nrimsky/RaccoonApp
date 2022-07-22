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
    @State var showingDeleteAlert = false
    
    var body: some View {
        let startDate = Binding(
            get: { Helpers.stringToDate(habit.startDay) },
            set: { habit.startDay = Helpers.dateToString($0) }
        )
        let endDate = Binding(
            get: { Helpers.stringToDate(habit.endDay, fallback: Helpers.stringToDate(habit.startDay)) },
            set: { habit.endDay = Helpers.dateToString($0) }
        )
        return ZStack(alignment: .bottom) {
            Form {
                Section(header: Text("Habit")) {
                    TextField("Something you want to do every day", text: $habit.title).font(Font.custom(Helpers.fontName, size: UIFont.labelFontSize))
                }
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: startDate, in: ...endDate.wrappedValue, displayedComponents: [.date])
                    if habit.endDay == "" {
                        Text("No end date")
                        AppButton(type: .normal, onPress: {habit.endDay = habit.startDay}, text: "Add End Date")
                    } else {
                        DatePicker("End Date", selection: endDate, in: startDate.wrappedValue...,
                                   displayedComponents: [.date])
                        AppButton(type: .normal, onPress: {habit.endDay = ""}, text: "No End Date")
                    }
                }
                Section() {
                    AppButton(type: .normal, onPress: {presentationMode.wrappedValue.dismiss()}, text: "Done")
                }
                Section() {
                    AppButton(type: .destructive, onPress: {showingDeleteAlert = true}, text: "Delete")
                }.alert("Are you sure you want to delete this habit ?", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) {
                        showingDeleteAlert = false
                    }
                    Button("Delete", role: .destructive) {
                        appState.delete(habit: habit)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            Image("StandingRaccoon2")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
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

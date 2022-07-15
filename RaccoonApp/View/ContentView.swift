//
//  ContentView.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 14/07/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @State var date = Date()
    @State var showDatePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if showDatePicker {
                        DatePicker(
                            "Start Date",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                    }
                    ForEach(appState.habits) { habit in
                        if habit.show(on: date) {
                            HabitItem(habit: habit, date: $date)
                                .padding(4)
                        }
                    }
                    Spacer()
                }
                .padding(12)
            }.navigationBarTitle(Helpers.dateToString(date)).toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showDatePicker.toggle()
                    }){Image(systemName: "calendar")}
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddNewView()) {
                        Image(systemName: "plus")
                    }
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView().environmentObject(AppState())
    }
}

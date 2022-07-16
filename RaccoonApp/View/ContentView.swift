//
//  ContentView.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 14/07/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @State var showDatePicker = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Image("StandingRaccoon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                ScrollView {
                    VStack(spacing: 0) {
                        if showDatePicker {
                            Button("Go to today") { appState.viewingDate = Date() }
                            DatePicker(
                                "Start Date",
                                selection: $appState.viewingDate,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.graphical)
                            .padding(6)
                            
                        }
                        Divider()
                        ForEach(appState.habitsToShow) { habit in
                            HabitItem(habit: habit, date: $appState.viewingDate)
                        }
                        Spacer()
                    }
                    .padding(12)
                    Spacer()
                }
            }.navigationBarTitle("\(Helpers.dateToString(appState.viewingDate))").toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showDatePicker.toggle()
                    }){
                        if showDatePicker {
                            Text("Hide calendar")
                        } else {
                            Image(systemName: "calendar")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        appState.viewingDate = Date()
                    }){
                        Image("RaccoonFace").resizable().frame(width: 36, height: 36, alignment: .leading)
                    }
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

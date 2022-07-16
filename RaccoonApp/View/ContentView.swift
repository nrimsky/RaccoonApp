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
            ZStack(alignment: .bottom) {
                Image("StandingRaccoon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                ScrollView {
                    VStack(spacing: 0) {
                        if showDatePicker {
                            DatePicker(
                                "Start Date",
                                selection: $date,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.graphical)
                            .padding(6)
                            
                        }
                        Divider()
                        ForEach(appState.habits) { habit in
                            
                            if habit.show(on: date) {
                                HabitItem(habit: habit, date: $date)
                            }
                            
                        }
                        Spacer()
                    }
                    .padding(12)
                    Spacer()
                }
            }.navigationBarTitle("\(Helpers.dateToString(date))").toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showDatePicker.toggle()
                    }){
                        if showDatePicker {
                            Text("Hide calendar")
                        } else {
                            Image(systemName: "calendar")
                        }
                    }.foregroundColor({
                        showDatePicker ? .primary : .accentColor
                    }())
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        date = Date()
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

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
        let showHabits = appState.habits.filter{$0.show(on: appState.viewingDate) }
        return NavigationView {
            ZStack(alignment: .bottom) {
                if showHabits.filter {!$0.wasAchievedOn(appState.viewingDate)}.count == 0 {
                    Image("StandingRaccoon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } else {
                    Image("StandingRaccoon2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                ScrollView {
                    VStack(alignment: .center, spacing: 0) {
                        if showDatePicker {
                            DatePicker(
                                "Start Date",
                                selection: $appState.viewingDate,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.graphical)
                            .frame(width: 300, height: 300)
                            .padding(12)
                        }
                        Divider()
                        if showHabits.count == 0 {
                            Text("🦝 Hello there human! You haven't added any habits for this day yet. Press + to add a new habit.")
                                .font(Font.custom(Helpers.fontName, size: 21))
                                .foregroundColor(.gray)
                                .padding(64)
                        }
                        ForEach(showHabits) { habit in
                            HabitItem(habit: habit, date: $appState.viewingDate)
                        }
                        Spacer()
                    }
                    .padding(12)
                    Spacer()
                }
            }.navigationBarTitle("\(Helpers.dateToString(appState.viewingDate))").toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        appState.viewingDate = Date()
                    }){
                        Image("RaccoonFace").resizable().frame(width: 42, height: 42, alignment: .leading)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showDatePicker {
                        AppButton(type: .normal, onPress: {showDatePicker.toggle()}, text: "Hide calendar")
                    } else {
                        Button(action: {showDatePicker.toggle()}){
                            Image(systemName: "calendar")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: StatsView()) {
                        Image(systemName: "chart.bar.doc.horizontal")
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

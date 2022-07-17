//
//  StatsView.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 17/07/2022.
//

import SwiftUI

enum ChartType {
    case week
    case month
    case year
    case allTime
}

struct StatsView: View {
    
    @EnvironmentObject var appState: AppState
    @State var currentHabit: Habit? = nil
    @State var chartType: ChartType = .week
    
    var body: some View {
        return ScrollView {
            if let habitStats = currentHabit?.monthData(referenceDate: appState.viewingDate) {
                VStack(alignment: .leading, spacing: 20) {
                    Text(currentHabit?.title ?? "")
                        .font(Font.custom(Helpers.fontName, size: 21))
                    BarChart(barColor: .accentColor, data: habitStats)
                }.padding([.leading, .trailing, .bottom], 20)
            }
        }
        .navigationTitle("Month overview \(Helpers.dateToMonth(appState.viewingDate))")
        .toolbar {
            Menu("Select habit") {
                ForEach(appState.habits) { habit in
                    AppButton(type: .normal, onPress: { currentHabit = habit }, text: habit.title)
                }
            }
        }
        .onAppear {
            currentHabit = appState.habits[0]
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        let habits = Helpers.mockHabits()
        let appState = AppState()
        appState.add(habit: habits[0])
        appState.add(habit: habits[1])
        return StatsView().environmentObject(appState)
    }
}

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
    @State var dateRange: Range<Date> = Range<Date>(uncheckedBounds: (Date().startOfMonth(), Date().endOfMonth()))
    
    func show(habit: Habit) -> Bool {
        if Helpers.stringToDate(habit.startDay) <= dateRange.upperBound {
            if habit.endDay != "" {
                if Helpers.stringToDate(habit.endDay) >= dateRange.lowerBound {
                    return true
                }
            } else {
                return true
            }
        }
        return false
    }
    
    var body: some View {
        return ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                YearMonthCalendarView(dateRange: $dateRange)
                if let habitStats = currentHabit?.monthData(referenceDate: dateRange.lowerBound) {
                    Text(currentHabit?.title ?? "")
                        .font(Font.custom(Helpers.fontName, size: 21))
                    BarChart(barColor: .accentColor, data: habitStats)
                }
            }.padding([.leading, .trailing, .bottom], 20)
        }
        .navigationTitle("\(Helpers.dateToMonth(dateRange.lowerBound)) month overview")
        .toolbar {
            Menu("Select habit") {
                ForEach(appState.habits) { habit in
                    if show(habit: habit) {
                        AppButton(type: .normal, onPress: { currentHabit = habit }, text: habit.title)
                    }
                }
            }
        }
        .onAppear {
            currentHabit = appState.habits.first(where: show)
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

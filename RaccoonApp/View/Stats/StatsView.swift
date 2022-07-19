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
    @State var showDownload: Bool = false
    let encoder = JSONEncoder()
    
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
            VStack(alignment: .leading, spacing: 8) {
                YearMonthCalendarView(dateRange: $dateRange)
                if let habitStats = currentHabit?.monthData(referenceDate: dateRange.lowerBound) {
                    Text(currentHabit?.title ?? "")
                        .font(Font.custom(Helpers.fontName, size: 24))
                    Text("\(Helpers.dateToMonth(dateRange.lowerBound)): \(Helpers.format(score: currentHabit?.monthScore(referenceDate: dateRange.lowerBound) ?? 0))%")
                        .font(Font.custom(Helpers.fontName, size: 21))
                    BarChart(barColor: .accentColor, data: habitStats)
                } else {
                    Text("🦝 This month doesn't have any habits yet. Go back and press + to add a new habit.")
                        .font(Font.custom(Helpers.fontName, size: 21))
                        .foregroundColor(.gray)
                        .padding(64)
                }
            }.padding([.leading, .trailing, .bottom], 20)
                .onAppear {
                    currentHabit = appState.habits.first(where: show)
                }
        }
        .navigationTitle("Overview")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu("Select habit") {
                    ForEach(appState.habits) { habit in
                        if show(habit: habit) {
                            AppButton(type: .normal, onPress: { currentHabit = habit }, text: habit.title)
                        }
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showDownload = true
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                })
            }
        }
        .sheet(isPresented: $showDownload) {
            ActivityView(text: appState.toText())
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

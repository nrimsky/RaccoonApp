//
//  HabitItem.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 15/07/2022.
//

import SwiftUI

struct HabitItem: View {
    
    @ObservedObject var habit: Habit
    @Binding var date: Date
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            NavigationLink(destination: EditView(habit: habit)) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.title).lineLimit(5)
                    Text(habit.description).lineLimit(5)
                }
            }.foregroundColor(.primary)
            Spacer()
            Image(systemName: habit.wasAchievedOn(date) ? "circle.fill" : "circle.dotted").frame(width: 30, height: 30)
                .onTapGesture {
                    withAnimation {
                        if habit.wasAchievedOn(date) {
                            habit.markUnachieved(on: date)
                        } else {
                            habit.markAchieved(on: date)
                        }
                    }
                }
        }
    }
}

struct HabitItem_Previews: PreviewProvider {
    static var previews: some View {
        let habits = Helpers.mockHabits()
        HabitItem(habit: habits[0], date: .constant(Date()))
    }
}

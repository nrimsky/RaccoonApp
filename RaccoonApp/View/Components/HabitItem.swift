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
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .trailing) {
                NavigationLink(destination: EditView(habit: habit)) {
                    HStack(alignment: .center, spacing: 2) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(habit.title)
                                .font(Font.custom(Helpers.fontName, size: 21))
                                .lineLimit(5)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }.padding(.trailing, 34)
                }.foregroundColor(.primary)
                ZStack(alignment: .center) {
                    Color.white.frame(width: 50, height: 50)
                    if habit.wasAchievedOn(date) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.green)
                        
                    } else {
                        Image(systemName:  "circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                    }
                    
                    
                }
                .onTapGesture {
                    withAnimation {
                        if habit.wasAchievedOn(date) {
                            habit.markUnachieved(on: date)
                        } else {
                            habit.markAchieved(on: date)
                        }
                        try? appState.persist()
                        Helpers.hapticGenerator.impactOccurred()
                    }
                }
            }.padding([.top, .bottom], 6)
            Divider()
        }.padding([.leading, .trailing], 6)
    }
}

struct HabitItem_Previews: PreviewProvider {
    static var previews: some View {
        let habits = Helpers.mockHabits()
        HabitItem(habit: habits[0], date: .constant(Date()))
    }
}

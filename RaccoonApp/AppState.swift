//
//  AppState.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 14/07/2022.
//

import Combine
import Foundation

class AppState: ObservableObject {
    
    @Published var habits: [Habit] = []
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        let h1 = Habit()
        let h2 = Habit()
        h1.title = "Brush teeth"
        h1.description = "Brush teeth for 2 minutes twice in a day"
        h1.startDay = Helpers.dateToString(Date())
        h1.achievedOn = Set([Helpers.dateToString(Date())])
        h2.title = "Squats"
        h2.description = "Do 30 body weight squats"
        h2.startDay = Helpers.dateToString(Date())
        h2.achievedOn = Set([Helpers.dateToString(Date())])
        habits = [h1, h2]
        
        for habit in habits {
            habit.objectWillChange
                .sink(receiveValue: { _ in self.objectWillChange.send() })
                .store(in: &subscriptions)
        }
    }
    
    func add(habit: Habit) {
        habits.append(habit)
        habit.objectWillChange
            .sink(receiveValue: { _ in self.objectWillChange.send() })
            .store(in: &subscriptions)
    }
}

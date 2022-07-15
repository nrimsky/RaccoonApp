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
        habits = Helpers.mockHabits()
        for habit in habits {
            habit.objectWillChange
                .sink(receiveValue: { [weak self] in self?.objectWillChange.send() })
                .store(in: &subscriptions)
        }
    }
    
    func add(habit: Habit) {
        habits.append(habit)
        habit.objectWillChange
            .sink(receiveValue: { [weak self] in self?.objectWillChange.send() })
            .store(in: &subscriptions)
    }
    
    func delete(habit: Habit) {
        habits.removeAll(where: {$0.id == habit.id})
    }
}

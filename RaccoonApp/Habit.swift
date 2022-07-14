//
//  Habit.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 14/07/2022.
//

import Foundation

class Habit: Hashable, Identifiable, ObservableObject {
    
    static func == (lhs: Habit, rhs: Habit) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    let id = UUID()
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var startDay: String = ""
    @Published var endDay: String = ""
    @Published var achievedOn = Set<String>()

    
    init() {
        self.startDay = Helpers.dateToString(Date())
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

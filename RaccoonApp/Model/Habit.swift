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
    
    func wasAchievedOn(_ date: Date) -> Bool {
        return achievedOn.contains(Helpers.dateToString(date))
    }
    
    func markAchieved(on date: Date) {
        achievedOn.insert(Helpers.dateToString(date))
    }
    
    func markUnachieved(on date: Date) {
        achievedOn.remove(Helpers.dateToString(date))
    }
    
    func show(on date: Date) -> Bool {
        if Calendar.current.numberOfDaysBetween(Helpers.stringToDate(startDay), and: date) < 0 {
            return false
        }
        if endDay != "" {
            if Calendar.current.numberOfDaysBetween(Helpers.stringToDate(endDay), and: date) > 0 {
                return false
            }
        }
        return true
    }
    
}

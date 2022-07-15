//
//  Habit.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 14/07/2022.
//

import Foundation

class Habit: Hashable, Identifiable, ObservableObject, Codable {
    
    static func == (lhs: Habit, rhs: Habit) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    let id = UUID()
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var startDay: String = ""
    @Published var endDay: String = ""
    @Published var achievedOn = Set<String>()
    @Published var isEditing: Bool = false

    
    init() {
        self.startDay = Helpers.dateToString(Date())
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        startDay = try values.decode(String.self, forKey: .startDay)
        endDay = try values.decode(String.self, forKey: .endDay)
        achievedOn = try values.decode(Set<String>.self, forKey: .achievedOn)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(startDay, forKey: .startDay)
        try container.encode(endDay, forKey: .endDay)
        try container.encode(achievedOn, forKey: .achievedOn)
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
        if isEditing {
            return true
        }
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
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case startDay
        case endDay
        case achievedOn
    }
    
}


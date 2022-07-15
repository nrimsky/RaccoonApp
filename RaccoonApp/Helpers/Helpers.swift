//
//  Helpers.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 14/07/2022.
//

import Foundation

struct Helpers {
    
    static var dateFromatter: DateFormatter  = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        return formatter
    }()
    
    static let persistenceManager = PersistenceManager()
    
    static func dateToString(_ date: Date) -> String {
        return dateFromatter.string(from: date)
    }
    
    static func stringToDate(_ string: String) -> Date {
        return Calendar.current.startOfDay(for: dateFromatter.date(from: string) ?? Date())
    }
    
    static func mockHabits() -> [Habit] {
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
        return [h1, h2]
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}
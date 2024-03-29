//
//  Helpers.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 14/07/2022.
//

import SwiftUI
import Foundation

struct Helpers {
    
    static let fontName = "PatrickHand-Regular"
    static let appFont = UIFont(name: Helpers.fontName, size: UIFont.labelFontSize)
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    
    static var hapticGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    static var dateFromatter: DateFormatter  = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        return formatter
    }()
    
    static var dateFormatterMonth: DateFormatter  = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()
    
    static var monthShortFormatter: DateFormatter  = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
    
    static var yearShortFormatter: DateFormatter  = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy"
        return formatter
    }()
    
    static let persistenceManager = PersistenceManager()
    
    static func dateToString(_ date: Date) -> String {
        return dateFromatter.string(from: date)
    }
    
    static func stringToDate(_ string: String, fallback: Date? = nil) -> Date {
        return Calendar.current.startOfDay(for: (dateFromatter.date(from: string) ?? fallback) ?? Date())
    }
    
    static func dateToMonth(_ date: Date) -> String {
        return dateFormatterMonth.string(from: date)
    }
    
    static func mockHabits() -> [Habit] {
        let h1 = Habit()
        let h2 = Habit()
        h1.title = "Brush teeth"
        h1.startDay = Helpers.dateToString(Date())
        h1.achievedOn = Set([Helpers.dateToString(Date())])
        h2.title = "Squats"
        h2.startDay = Helpers.dateToString(Date())
        h2.achievedOn = Set([Helpers.dateToString(Date())])
        return [h1, h2]
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func format(score: Double) -> String {
        return String(Double((score * 100.0).rounded()))
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

extension Date {
    mutating func addDays(n: Int) {
        let cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }
    
    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(from:
                                        Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    func getAllDays() -> [Date] {
        var days = [Date]()
        
        let calendar = Calendar.current
        
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        var day = firstDayOfTheMonth()
        
        for _ in 1...range.count
        {
            days.append(day)
            day.addDays(n: 1)
        }
        
        return days
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

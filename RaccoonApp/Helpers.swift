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
    
    
    static func dateToString(_ date: Date) -> String {
        return dateFromatter.string(from: date)
    }
    
    static func stringToDate(_ string: String) -> Date? {
        return dateFromatter.date(from: string)
    }
    
}

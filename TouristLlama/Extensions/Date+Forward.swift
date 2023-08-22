//
//  Date.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

extension Date {
    
    enum ForwardAmount {
        case day
        case days(Int)
        case week
        case weeks(Int)
        case month
        case months(Int)
        case year
        case years(Int)
    }
    
    static func forward(_ amount: ForwardAmount) -> Date {
        var date: Date?
        switch amount {
        case .day:
            date = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        case .days(let days):
            date = Calendar.current.date(byAdding: .day, value: days, to: Date())
        case .week:
            date = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: Date())
        case .weeks(let weeks):
            date = Calendar.current.date(byAdding: .weekOfMonth, value: weeks, to: Date())
        case .month:
            date = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        case .months(let months):
            date = Calendar.current.date(byAdding: .month, value: months, to: Date())
        case .year:
            date = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        case .years(let years):
            date = Calendar.current.date(byAdding: .year, value: years, to: Date())
        }
        return date ?? Date()
    }
    
    public var removeTimeStamp : Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return self
        }
        return date
    }
    
    public var timeIntervalSince1970Milliseconds: TimeInterval {
        self.timeIntervalSince1970 * 1000
    }
    
    init(timeIntervalSince1970Milliseconds: TimeInterval) {
        self.init(timeIntervalSince1970: timeIntervalSince1970Milliseconds / 1000)
    }

}

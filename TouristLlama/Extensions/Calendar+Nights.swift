//
//  Calendar+Nights.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int? {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day
    }
    
    func numberOfDaysBetween(_ from: TimeInterval, and to: TimeInterval) -> Int? {
        let startDate = Date(timeIntervalSince1970: from)
        let endDate = Date(timeIntervalSince1970: to)
        let fromDate = startOfDay(for: startDate)
        let toDate = startOfDay(for: endDate)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day
    }

}

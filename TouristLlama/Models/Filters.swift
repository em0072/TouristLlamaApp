//
//  Filters.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 25/08/2023.
//

import Foundation

struct Filters {
    var tripStyle: TripStyle?
    var startDate: Date?
    var endDate: Date?
    
    var settedCount: Int {
        var count = 0
        if tripStyle != nil {
            count += 1
        }
        
        if startDate != nil {
            count += 1
        }

        if endDate != nil {
            count += 1
        }
        return count
    }
    
    var isEmpty: Bool {
        tripStyle == nil && startDate == nil && endDate == nil
    }
    
    mutating func clear() {
        tripStyle = nil
        startDate = nil
        endDate = nil
    }
}

//
//  TimeInterval+Format.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

extension TimeInterval {
    
    func dateToString(format: Date.DateStyleOutput) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        let date = Date(timeIntervalSince1970: self)
        return formatter.string(from: date)
    }

}

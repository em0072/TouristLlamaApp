//
//  Date+Format.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

extension Date {
    enum DateStyleOutput: String {
        case ddMMMyyyy = "dd MMM, yyyy"
        case ddMMM = "dd MMM"
        case yyyy = "yyyy"
    }

    func toString(format: DateStyleOutput) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String? {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }


}
struct DateHandler {
    
    enum DateStyleOutput: String {
        case ddMMMyyyy = "dd MMM, yyyy"
        case ddMMM = "dd MMM"
        case yyyy = "yyyy"
    }

    var dateStyleOutput: DateStyleOutput {
        didSet {
            formatter.dateFormat = dateStyleOutput.rawValue
        }
    }
    let formatter: DateFormatter
    
    init(dateStyleOutput: DateStyleOutput = .ddMMMyyyy) {
        self.dateStyleOutput = dateStyleOutput
        formatter = DateFormatter()
        formatter.dateFormat = dateStyleOutput.rawValue
    }
    
    
    func dateToString(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        return formatter.string(from: date)
    }

//    func dateToString(_ timeInterval: TimeInterval?) -> String? {
//        guard let timeInterval = timeInterval else { return nil }
//        let date = Date(timeIntervalSince1970: timeInterval)
//        return formatter.string(from: date)
//    }

    func stringToDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        return formatter.date(from: dateString)
    }
    
    func dateToTimeInterval(_ date: Date?) -> TimeInterval? {
        return date?.timeIntervalSince1970
    }
    
    func timeIntervalToDate(_ timeInterval: TimeInterval?) -> Date? {
        guard let timeInterval = timeInterval else {
            return nil
        }
        return Date(timeIntervalSince1970: timeInterval)
    }
    
//    func dateToTimestamp(_ date: Date?) -> Timestamp? {
//        guard let date = date else {
//            return nil
//        }
//        return Timestamp(date: date)
//    }
//    
//    func timestampToDate(_ timestamp: Timestamp?) -> Date? {
//        guard let timestamp = timestamp else {
//            return nil
//        }
//        let timeInterval = TimeInterval(timestamp.seconds)
//        return Date(timeIntervalSince1970: timeInterval)
//    }
//
}

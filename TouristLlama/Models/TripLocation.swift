//
//  TripLocation.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation
import CoreLocation

struct TripLocation: Equatable {
    let title: String
    let country: String
    let point: CLLocation?
    let flag: String?
        
    init(title: String, country: String, point: CLLocation?, flag: String?) {
        self.title = title
        self.country = country
        self.point = point
        self.flag = flag
    }
    
    var nameAndFlag: String {
        var name = title
        if let flag = flag {
            name += " \(flag)"
        }
        return name
    }

    static var test: TripLocation {
        TripLocation(title: "Purmerend, The Netherlands",
                     country: "The Netherlands",
                     point: .init(latitude: 52.5103769, longitude: 4.9446193),
                     flag: "🇳🇱")
    }
}

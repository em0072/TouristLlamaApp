//
//  TripLocation.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation
import CoreLocation

struct TripLocation: Equatable, Hashable {
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
    
    static var paris: TripLocation {
        TripLocation(title: "Paris, France",
                     country: "France",
                     point: .init(latitude: 48.86, longitude: 2.35),
                     flag: "🇫🇷")
    }
    
    static var zermatt: TripLocation {
        TripLocation(title: "Zermatt, Switzerland",
                     country: "Switzerland",
                     point: .init(latitude: 46.01, longitude: 7.44),
                     flag: "🇨🇭")
    }
    
    static var amsterdam: TripLocation {
        TripLocation(title: "Amsterdam, The Netherlands",
                     country: "The Netherlands",
                     point: .init(latitude: 52.3676, longitude: 4.9041),
                     flag: "🇳🇱")
    }

}

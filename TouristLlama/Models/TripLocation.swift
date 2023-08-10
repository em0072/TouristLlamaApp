//
//  TripLocation.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation
import CoreLocation

struct TripLocation {
    let title: String
    let city: String
    let country: String
    let point: CLLocation?
    let region: CLRegion?
    let flag: String?
    
    static var test: TripLocation {
        TripLocation(title: "Amsterdam, The Netherlands",
                     city: "Amsterdam",
                     country: "The Netherlands",
                     point: CLLocation(latitude: 52.3676, longitude: 4.9041),
                     region: .init(),
                     flag: "🇳🇱")
    }
}

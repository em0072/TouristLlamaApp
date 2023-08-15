//
//  Trip.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

struct Trip: Identifiable {
    let id: UUID
    let name: String
    let style: TripStyle
    let location: TripLocation
    let startDate: Date
    let endDate: Date
    let description: String
    let photo: TripPhoto
    let isPublic: Bool
    
    init(name: String, style: TripStyle, location: TripLocation, startDate: Date, endDate: Date, description: String, photo: TripPhoto, isPublic: Bool) {
        self.id = UUID()
        self.name = name
        self.style = style
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.photo = photo
        self.isPublic = isPublic
    }
    
    static var testFuture: Trip {
        Trip(name: "My Future Trip",
             style: .leisure,
             location: .test,
             startDate: Date().addingTimeInterval(60 * 60 * 24 * 1),
             endDate: Date().addingTimeInterval(60 * 60 * 24 * 7),
             description: "My amazing trip",
             photo: .test,
             isPublic: true)
    }
    
    static var testOngoing: Trip {
        Trip(name: "My Ongoing Trip",
             style: .leisure,
             location: .test,
             startDate: Date().addingTimeInterval(60 * 60 * 24 * -1),
             endDate: Date().addingTimeInterval(60 * 60 * 24 * 7),
             description: "My amazing trip",
             photo: .test,
             isPublic: true)
    }

    static var testPast: Trip {
        Trip(name: "My Past Trip",
             style: .leisure,
             location: .test,
             startDate: Date().addingTimeInterval(60 * 60 * 24 * -7),
             endDate: Date().addingTimeInterval(60 * 60 * 24 * -1),
             description: "My amazing trip",
             photo: .test,
             isPublic: true)
    }
}

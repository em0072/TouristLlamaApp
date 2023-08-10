//
//  Trip.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

struct Trip {
    let name: String
    let style: TripStyle
    let location: TripLocation
    let startDate: Date
    let endDate: Date
    let description: String
    let photo: TripPhoto
    let isPublic: Bool
    
    init(name: String, style: TripStyle, location: TripLocation, startDate: Date, endDate: Date, description: String, photo: TripPhoto, isPublic: Bool) {
        self.name = name
        self.style = style
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.photo = photo
        self.isPublic = isPublic
    }
}

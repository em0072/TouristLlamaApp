//
//  Trip.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

struct Trip: Identifiable {
    let id: String
    let name: String
    let style: TripStyle?
    let location: TripLocation
    let startDate: Date
    let endDate: Date
    let description: String
    let photo: TripPhoto
    let isPublic: Bool
    let participants: [User]
    let ownerId: String
    var chat: TripChat?
    
    init(id: String,
         name: String,
         style: TripStyle?,
         location: TripLocation,
         startDate: Date,
         endDate: Date,
         description: String,
         photo: TripPhoto,
         isPublic: Bool,
         participants: [User] = [],
         ownerId: String,
         discussion: TripChat? = nil) {
        self.id = id
        self.name = name
        self.style = style
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.photo = photo
        self.isPublic = isPublic
        self.participants = participants
        self.ownerId = ownerId
        self.chat = discussion
    }
//    init(name: String,
//         style: TripStyle?,
//         location: TripLocation,
//         startDate: Date,
//         endDate: Date,
//         description: String,
//         photo: TripPhoto,
//         isPublic: Bool,
//         participants: [User] = [],
//         ownerId: String) {
//        self.id = UUID()
//        self.name = name
//        self.style = style
//        self.location = location
//        self.startDate = startDate
//        self.endDate = endDate
//        self.description = description
//        self.photo = photo
//        self.isPublic = isPublic
//        self.participants = participants
//    }
}

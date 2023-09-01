//
//  Trip+test.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 15/08/2023.
//

import Foundation

extension Trip {
    
    static var testFuture: Trip {
        Trip(id: "1232ew",
             name: "My Future Trip",
             style: .leisure,
             location: .test,
             startDate: Date().addingTimeInterval(60 * 60 * 24 * 1),
             endDate: Date().addingTimeInterval(60 * 60 * 24 * 7),
             description: "My amazing trip",
             photo: .test,
             isPublic: true,
             participants: [.test, .testNotOwner, .testNoPhoto],
             ownerId: User.test.id)
    }
    
    static var testOngoing: Trip {
        Trip(id: "dfcfvgr34",
             name: "My Ongoing Trip",
             style: .leisure,
             location: .test,
             startDate: Date().addingTimeInterval(60 * 60 * 24 * -1),
             endDate: Date().addingTimeInterval(60 * 60 * 24 * 7),
             description: "My amazing trip",
             photo: .test,
             isPublic: true,
             participants: [.test, .testNotOwner, .testNoPhoto],
             ownerId: User.test.id,
             requests: [
                .testRequestPending
                       ])
    }

    static var testPast: Trip {
        Trip(id: "09iurjvrlnw",
             name: "My Past Trip",
             style: .leisure,
             location: .test,
             startDate: Date().addingTimeInterval(60 * 60 * 24 * -7),
             endDate: Date().addingTimeInterval(60 * 60 * 24 * -1),
             description: "My amazing trip",
             photo: .test,
             isPublic: true,
             participants: [.test, .testNotOwner, .testNoPhoto],
             ownerId: User.test.id)
    }
    
}

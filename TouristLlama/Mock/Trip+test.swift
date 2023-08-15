//
//  Trip+test.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 15/08/2023.
//

import Foundation

extension Trip {
    
    static var testFuture: Trip {
        Trip(name: "My Future Trip",
             style: .leisure,
             location: .test,
             startDate: Date().addingTimeInterval(60 * 60 * 24 * 1),
             endDate: Date().addingTimeInterval(60 * 60 * 24 * 7),
             description: "My amazing trip",
             photo: .test,
             isPublic: true,
             participants: [.test, .test, .testNoPhoto])
    }
    
    static var testOngoing: Trip {
        Trip(name: "My Ongoing Trip",
             style: .leisure,
             location: .test,
             startDate: Date().addingTimeInterval(60 * 60 * 24 * -1),
             endDate: Date().addingTimeInterval(60 * 60 * 24 * 7),
             description: "My amazing trip",
             photo: .test,
             isPublic: true,
             participants: [.test, .test, .testNoPhoto])
    }

    static var testPast: Trip {
        Trip(name: "My Past Trip",
             style: .leisure,
             location: .test,
             startDate: Date().addingTimeInterval(60 * 60 * 24 * -7),
             endDate: Date().addingTimeInterval(60 * 60 * 24 * -1),
             description: "My amazing trip",
             photo: .test,
             isPublic: true,
             participants: [.test, .test, .testNoPhoto])
    }
    
}

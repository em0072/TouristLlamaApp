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
    
    static func testRequest(_ request: TripRequest) -> Trip {
        Trip(id: "09iurjvrlnw",
             name: "My Past Trip",
             style: .leisure,
             location: .test,
             startDate: Date().addingTimeInterval(60 * 60 * 24 * -7),
             endDate: Date().addingTimeInterval(60 * 60 * 24 * -1),
             description: "My amazing trip",
             photo: .test,
             isPublic: true,
             participants: [.testNotOwner, .testNoPhoto],
             ownerId: User.testNotOwner.id,
             requests: [
                request
                       ])
    }
    
    static var testParis: Trip {
        Trip(id: "testParis",
             name: "Paris Museum Run",
             style: .cultural,
             location: .paris,
             startDate: Date().addingTimeInterval(60 * 60 * 24 * 1),
             endDate: Date().addingTimeInterval(60 * 60 * 24 * 7),
             description: "We are going to complete a museum run as we want to see the most important pieces of art during our trip. If you love museums and a good company, you are very welcome to join us!",
             photo: .paris,
             isPublic: true,
             participants: [.testBob, .testAnabel],
             ownerId: User.testBob.id)
    }

    static var testZermatt: Trip {
        Trip(id: "testZermatt",
             name: "Zeramtt hike",
             style: .natureAndWildlife,
             location: .zermatt,
             startDate: Date().addingTimeInterval(60 * 60 * 24 * 3),
             endDate: Date().addingTimeInterval(60 * 60 * 24 * 6),
             description: "Mountains are my love! I love hiking in the mountatins and in this trip want to explore mountains around Zermatt. Pack your shoes and come join me for a hike you will remember for a long time!",
             photo: .zermatt,
             isPublic: true,
             participants: [.testHanna],
             ownerId: User.testHanna.id)
    }
    
    static var testAmsterdam: Trip {
        Trip(id: "testAmsterdam",
             name: "Amsterdam Vibes",
             style: .adventure,
             location: .amsterdam,
             startDate: Date().addingTimeInterval(60 * 60 * 24 * 7),
             endDate: Date().addingTimeInterval(60 * 60 * 24 * 14),
             description: "Amsterdam and surroundings are amazing! I want to fill this trip with Dutch vibes - not weed and re light district, but true Dutch Vibes. We gonna cycle a lot, eat haring and stroopwafels, watch windmolen and wear klomps!",
             photo: .amsterdam,
             isPublic: true,
             participants: [.testBob, .testHanna],
             ownerId: User.testBob.id,
             chat: .testAmsterdam)
    }

}

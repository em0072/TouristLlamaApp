//
//  Trip.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

struct Trip: Identifiable, Equatable {
    let id: String
    let name: String
    let style: TripStyle?
    let location: TripLocation
    let startDate: Date
    let endDate: Date
    let description: String
    let photo: TripPhoto
    var lastMessage: ChatMessage?
    let isPublic: Bool
    var participants: [User]
    let ownerId: String
    var chat: TripChat?
    var requests: [TripRequest]
    
    init(id: String,
         name: String,
         style: TripStyle?,
         location: TripLocation,
         startDate: Date,
         endDate: Date,
         description: String,
         photo: TripPhoto,
         lastMessage: ChatMessage? = nil,
         isPublic: Bool,
         participants: [User] = [],
         ownerId: String,
         chat: TripChat? = nil,
         requests: [TripRequest] = []) {
        self.id = id
        self.name = name
        self.style = style
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.photo = photo
        self.lastMessage = lastMessage
        self.isPublic = isPublic
        self.participants = participants
        self.ownerId = ownerId
        self.chat = chat
        self.requests = requests
    }
    
    mutating func upsert(tripRequest: TripRequest) {
        if let requestIndex = requests.lastIndex(where: { $0.id == tripRequest.id }) {
            requests[requestIndex] = tripRequest
        } else {
            requests.append(tripRequest)
        }
    }
    
    mutating func delete(tripRequest: TripRequest) {
        if let requestIndex = requests.lastIndex(where: { $0.id == tripRequest.id }) {
            requests.remove(at: requestIndex)
        }
    }
    
    mutating func add(participant: User) {
        participants.append(participant)
    }
    
    var requestsPendingCount: Int {
        let pendingRequests = requests.filter { $0.status == .requestPending }
        return pendingRequests.count
    }
    
    func hasRequests(with status: TripRequestStatus) -> Bool {
        for request in requests {
            if request.status == status {
                return true
            }
        }
        return false
    }

}

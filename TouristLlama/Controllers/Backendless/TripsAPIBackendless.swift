//
//  TripsAPIBackendless.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 14/08/2023.
//

import Foundation
import SwiftSDK
import Combine

class TripsAPIBackendless: TripsAPIProvider {
    
    private let serviceName = "TripsService"
    
    var tripsUpsertSubscription: RTSubscription?
    var participantsDeleteSubscription: RTSubscription?
    var tripRequestsUpsertSubscription: RTSubscription?
    var tripRequestsForUserUpsertSubscription: RTSubscription?
    var tripsDeleteSubscription: RTSubscription?

    var measure: TimeInterval = 0
    
    func create(trip: Trip) async throws -> Trip {
        return try await withCheckedThrowingContinuation { continuation in
            let backendlessTrip = BackendlessTrip(from: trip)
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "createTrip", parameters: backendlessTrip) { response in
                guard let backendlessTrip = response as? BackendlessTrip else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse data to backendless object"))
                    return
                }
                guard let trip = backendlessTrip.appObject else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse backendless object to app object"))
                    return
                }
                continuation.resume(returning: trip)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func getMyTrips() async throws -> [Trip] {
        return try await withCheckedThrowingContinuation { continuation in
            measure = Date().timeIntervalSince1970
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "getMyTrips", parameters: nil) { response in
                print("Request done in ", Date().timeIntervalSince1970 - self.measure)
                guard let tripsArray = response as? [BackendlessTrip] else {
                    continuation.resume(throwing: CustomError(text: "Can't cast to array"))
                    return
                }
                let trips = tripsArray.compactMap { $0.appObject }
                print("Mapping done in ", Date().timeIntervalSince1970 - self.measure)
                continuation.resume(returning: trips)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
        
    func editTrip(trip: Trip) async throws -> Trip {
        return try await withCheckedThrowingContinuation { continuation in
            let trip = BackendlessTrip(from: trip)
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "editTrip", parameters: trip) { response in
                guard let backendlessTrip = response as? BackendlessTrip else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse data to backendless object"))
                    return
                }
                guard let trip = backendlessTrip.appObject else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse backendless object to app object"))
                    return
                }
                continuation.resume(returning: trip)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func getExploreTrips(searchTerm: String, tripStyle: TripStyle?, startDate: Date?, endDate: Date?) async throws -> [Trip] {
        return try await withCheckedThrowingContinuation { continuation in
            var parameters: [String: Any] = .init()
            parameters["search"] = searchTerm
            if let tripStyle {
                parameters["tripStyle"] = tripStyle.rawValue
            }
            if let startDate {
                parameters["startDate"] = startDate.timeIntervalSince1970Milliseconds
            }
            if let endDate {
                parameters["endDate"] = endDate.timeIntervalSince1970Milliseconds
            }

            Backendless.shared.customService.invoke(serviceName: serviceName, method: "getTrips", parameters: parameters) { response in
                guard let tripsArray = response as? [BackendlessTrip] else {
                    continuation.resume(throwing: CustomError(text: "Can't cast to array"))
                    return
                }
                let trips = tripsArray.compactMap { $0.appObject }
                continuation.resume(returning: trips)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func sendJoinRequest(tripId: String, message: String) async throws -> TripRequest {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters: [String: Any] = ["tripId": tripId, "message": message]
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "joinRequest", parameters: parameters) { response in
                guard let blTripRequest = response as? BackendlessTripReqest else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse data to backendless object"))
                    return
                }
                guard let tripRequest = blTripRequest.appObject else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse backendless object to app object"))
                    return
                }
                continuation.resume(returning: tripRequest)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func getTrip(for tripId: String) async throws -> Trip {
        return try await withCheckedThrowingContinuation { continuation in
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "getTrip", parameters: tripId) { response in
                guard let blTrip = response as? BackendlessTrip else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse data to backendless object"))
                    return
                }
                guard let trip = blTrip.appObject else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse backendless object to app object"))
                    return
                }
                continuation.resume(returning: trip)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func subscribeToTripsUpdates(for trips: [Trip], onNewUpdate: @escaping (String) -> Void) {
        tripsUpsertSubscription?.stop()
        participantsDeleteSubscription?.stop()
        tripRequestsUpsertSubscription?.stop()
        tripRequestsForUserUpsertSubscription?.stop()
        
        let tripIds = trips.map { $0.id }
        
        let eventHandlerClauseTrip = Backendless.shared.data.ofTable("Trip").rt
        var whereClauseTripIdsString: String = ""
        for (i, tripId) in tripIds.enumerated() {
            whereClauseTripIdsString += "'\(tripId)'"
            if i != tripIds.count - 1 {
                whereClauseTripIdsString += ","
            }
        }
        let whereClauseTrip = "objectId in (\(whereClauseTripIdsString))"
        tripsUpsertSubscription = eventHandlerClauseTrip?.addUpsertListener(whereClause: whereClauseTrip, responseHandler: { dict in
            guard let tripId = dict["objectId"] as? String else { return }
            onNewUpdate(tripId)
        }, errorHandler: { fault in
            print("Error: \(fault.message ?? "")")
        })
        
        participantsDeleteSubscription = eventHandlerClauseTrip?.addDeleteRelationListener(relationColumnName: "participants", parentObjectIds: tripIds, responseHandler: { status in
            guard let tripId = status.parentObjectId else { return }
            onNewUpdate(tripId)
        }, errorHandler: { fault in
            print("Error: \(fault.message ?? "")")
        })

        let eventHandlerTripRequest = Backendless.shared.data.ofTable("TripRequest").rt
        let whereClauseTripRequest = "tripId in (\(whereClauseTripIdsString))"
        tripRequestsUpsertSubscription = eventHandlerTripRequest?.addUpsertListener(whereClause: whereClauseTripRequest, responseHandler: { dict in
            guard let tripId = dict["tripId"] as? String else { return }
            guard let applicantId = dict["applicantId"] as? String, Backendless.shared.userService.currentUser?.objectId != applicantId else { return }
            onNewUpdate(tripId)
        }, errorHandler: { fault in
            print("Error: \(fault.message ?? "")")
        })
        
        if let currentUserId = Backendless.shared.userService.currentUser?.objectId {
            let whereClauseTripRequestForUser = "applicantId = '\(currentUserId)'"
            tripRequestsForUserUpsertSubscription = eventHandlerTripRequest?.addUpsertListener(whereClause: whereClauseTripRequestForUser, responseHandler: { dict in
                guard let tripId = dict["tripId"] as? String else { return }
                onNewUpdate(tripId)
            }, errorHandler: { fault in
                print("Error: \(fault.message ?? "")")
            })
        }

    }

    func subscribeToTripsDeletion(for trips: [Trip], onDelete: @escaping (String) -> Void) {
        tripsDeleteSubscription?.stop()
        
        let tripIds = trips.map { $0.id }

        let eventHandlerClauseTrip = Backendless.shared.data.ofTable("Trip").rt
        var whereClauseTripIdsString: String = ""
        for (i, tripId) in tripIds.enumerated() {
            whereClauseTripIdsString += "'\(tripId)'"
            if i != tripIds.count - 1 {
                whereClauseTripIdsString += ","
            }
        }
        let whereClauseTrip = "objectId in (\(whereClauseTripIdsString))"
        tripsDeleteSubscription = eventHandlerClauseTrip?.addDeleteListener(whereClause: whereClauseTrip, responseHandler: { dict in
            guard let tripId = dict["objectId"] as? String else { return }
            onDelete(tripId)
        }, errorHandler: { fault in
            print("Error: \(fault.message ?? "")")
        })
    }

    
    func subscribeToTripDeletion(for tripId: String, onDelete: @escaping (String) -> Void) {
        let eventHandlerClauseTrip = Backendless.shared.data.ofTable("Trip").rt
        let whereClauseTrip = "objectId = '\(tripId)'"
        _ = eventHandlerClauseTrip?.addDeleteListener(whereClause: whereClauseTrip, responseHandler: { dict in
            guard let tripId = dict["objectId"] as? String else { return }
            onDelete(tripId)
        }, errorHandler: { fault in
            print("Error: \(fault.message ?? "")")
        })
    }

    func cancelJoinRequest(tripId: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "cancelRequest", parameters: tripId) { response in
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func answerTravelRequest(request: TripRequest, approved: Bool) async throws -> TripRequest {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters: [String: Any] = ["travelRequestId": request.id, "accepted": approved]
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "answerTravelRequest", parameters: parameters) { response in
                guard let blTripRequest = response as? BackendlessTripReqest else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse data to backendless object"))
                    return
                }
                guard let tripRequest = blTripRequest.appObject else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse backendless object to app object"))
                    return
                }
                continuation.resume(returning: tripRequest)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func removeUser(tripId: String, userId: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters: [String: Any] = ["tripId": tripId, "userId": userId]
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "removeUser", parameters: parameters) { response in
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func cancelInvite(tripId: String, userId: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters: [String: Any] = ["tripId": tripId, "userId": userId]
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "cancelInvite", parameters: parameters) { response in
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func sendJoinInvite(tripId: String, userId: String) async throws -> TripRequest {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters: [String: Any] = ["tripId": tripId, "userId": userId]
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "joinInvite", parameters: parameters) { response in
                guard let blTripRequest = response as? BackendlessTripReqest else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse data to backendless object"))
                    return
                }
                guard let tripRequest = blTripRequest.appObject else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse backendless object to app object"))
                    return
                }
                continuation.resume(returning: tripRequest)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func answerTravelInvite(request: TripRequest, accepted: Bool) async throws -> TripRequest {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters: [String: Any] = ["tripId": request.tripId, "accepted": accepted]
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "answerTravelInvite", parameters: parameters) { response in
                guard let blTripRequest = response as? BackendlessTripReqest else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse data to backendless object"))
                    return
                }
                guard let tripRequest = blTripRequest.appObject else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse backendless object to app object"))
                    return
                }
                continuation.resume(returning: tripRequest)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func leaveTrip(tripId: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "leaveTrip", parameters: tripId) { response in
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func deleteTrip(tripId: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "deleteTrip", parameters: tripId) { response in
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }

    func reportTrip(tripId: String, reason: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters: [String: Any] = ["tripId": tripId, "reason": reason]
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "reportTrip", parameters: parameters) { response in
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }

    }
}

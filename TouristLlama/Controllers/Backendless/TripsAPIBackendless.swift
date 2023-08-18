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
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "getMyTrips", parameters: nil) { response in
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
        
    private func save<Object: BackendlessObject>(object: Object) async throws -> Object {
        return try await withCheckedThrowingContinuation{ continuation in
            let dataStorage = Backendless.shared.data.of(object.type)
            dataStorage.save(entity: object) { savedObject in
                guard let backendlessObject = savedObject as? Object else {
                    continuation.resume(throwing: CustomError(text: "Couldn't read responce"))
                    return
                }
                continuation.resume(returning: backendlessObject)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }

        }
    }
}

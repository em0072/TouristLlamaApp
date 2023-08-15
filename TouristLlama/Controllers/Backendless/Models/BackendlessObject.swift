//
//  BackendlessObject.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 14/08/2023.
//

import Foundation

protocol BackendlessObject: NSObject {
    var objectId: String? { get set }
    
    var type: AnyClass { get }
}

extension BackendlessObject {
    var type: AnyClass {
        return Self.self
    }
}

//
//  User.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation

struct User {
    
    enum Property: String {
        case name
        case email
        
        var string: String {
            return self.rawValue
        }
    }
    
    let id: String
    let name: String
    let email: String
}

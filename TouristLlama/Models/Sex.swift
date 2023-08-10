//
//  Sex.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

enum Sex: Pickable {
    case none
    case male
    case female
    
    var rawValue: String {
        switch self {
        case .none:
            return ""
            
        case .male:
            return "mal"
            
        case .female:
            return "femal"
        }
    }
}

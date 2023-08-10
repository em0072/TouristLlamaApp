//
//  Local+Trip.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

extension String {
    
    enum Trip {
        enum Style {
            static let leisure = String.localized("tripStyleLeisure")
            static let active = String.localized("tripStyleActive")
        }
    }
    
    private static func localized(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key,
                                           value: nil,
                                           table: "Local+Trip")
    }
}

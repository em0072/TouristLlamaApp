//
//  Local+Terms.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 09/08/2023.
//

import Foundation

import Foundation

extension String {
    
    enum TermsAndConditions {
        static let title = String.localized("termsAndConditionsTitle")
        static let lastUpdated = String.localized("termsAndConditionsLastUpdated")
        static let date = String.localized("termsAndConditionsUpdateDate")
        static let body = String.localized("termsAndConditionsBody")
    }
    
    private static func localized(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key,
                                           value: nil,
                                           table: "Local+Terms")
    }
}

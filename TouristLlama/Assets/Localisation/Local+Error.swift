//
//  Local+Error.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import Foundation

extension String {
    
    enum Error {
        static let checkEmail = String.localized("checkEmail")
    }
    
    private static func localized(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key,
                                           value: nil,
                                           table: "Local+Error")
    }
}

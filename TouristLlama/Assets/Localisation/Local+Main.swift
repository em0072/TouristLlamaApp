//
//  Local+Main.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

extension String {
    
    enum Main {
        static let noResults = String.localized("noResults")
        static let `continue` = String.localized("continue")
        static let create = String.localized("create")

    }
    
    private static func localized(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key,
                                           value: nil,
                                           table: "Local+Main")
    }
}

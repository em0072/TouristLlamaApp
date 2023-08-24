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
        static let update = String.localized("update")
        static let cancel = String.localized("cancel")
        static let done = String.localized("done")
        
        static let camera = String.localized("camera")
        static let photoLibrary = String.localized("photoLibrary")
        
        static let charectersLeft = String.localized("charectersLeft")
        
        static let exploreTab = String.localized("exploreTab")
        static let myTripsTab = String.localized("myTripsTab")
        static let profileTab = String.localized("profileTab")
    }
    
    private static func localized(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key,
                                           value: nil,
                                           table: "Local+Main")
    }
}

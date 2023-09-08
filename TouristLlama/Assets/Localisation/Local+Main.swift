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
        static let remove = String.localized("remove")
        static let done = String.localized("done")
        static let search = String.localized("search")
        static let select = String.localized("select")
        static let accept = String.localized("accept")
        static let reject = String.localized("reject")
        static let unread = String.localized("unread")
        static let submit = String.localized("submit")
        static let or = String.localized("or")

        static let camera = String.localized("camera")
        static let photoLibrary = String.localized("photoLibrary")
        
        static let charectersLeft = String.localized("charectersLeft")
        
        static let exploreTab = String.localized("exploreTab")
        static let myTripsTab = String.localized("myTripsTab")
        static let notificationsTab = String.localized("notificationsTab")
        static let profileTab = String.localized("profileTab")
        
        // MARK: - Reporting
        static let report = String.localized("report")
        static let reportReason = String.localized("reportReason")
        static let reportReasonPromt = String.localized("reportReasonPromt")
        static let block = String.localized("block")
        static let blockTitle = String.localized("blockTitle")
        static let blockMessage = String.localized("blockMessage")
        static let unblock = String.localized("unblock")
        static let unblockTitle = String.localized("unblockTitle")
        static let unblockMessage = String.localized("unblockMessage")

    }
    
    private static func localized(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key,
                                           value: nil,
                                           table: "Local+Main")
    }
}

//
//  Logger.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 03/10/2023.
//

import Foundation
import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    /// All logs related to tracking and analytics.
    static let stat = Logger(subsystem: subsystem, category: "statistics")
    
    static let `default` = Logger(subsystem: subsystem, category: "error")
}

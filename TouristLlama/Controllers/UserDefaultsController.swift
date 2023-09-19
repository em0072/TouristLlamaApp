//
//  UserDefaultsController.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 31/08/2023.
//

import Foundation

class UserDefaultsController {
        
    init() {}
    
    func saveLast(messageId: String, for tripId: String) {
        UserDefaults.group.setValue(messageId, forKey: tripId)
    }
    
    func getLastMessageId(for tripId: String) -> String? {
        UserDefaults.group.string(forKey: tripId)
    }
}

extension UserDefaults {
    
    static var group: UserDefaults = { UserDefaults(suiteName: "group.touristLlamaApp.com")! }()

}

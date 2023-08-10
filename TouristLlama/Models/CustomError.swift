//
//  CustomError.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation

struct CustomError: LocalizedError {
    
    let text: String?
    
    init(text: String) {
        self.text = text
    }
    
    init() {
        self.text = nil
    }
    
    var errorDescription: String? {
        return text
    }
    
}


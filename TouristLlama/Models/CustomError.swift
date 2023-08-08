//
//  CustomError.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation

struct CustomError: LocalizedError {
    
    let text: String
    
    var errorDescription: String? {
        return text
    }
    
}


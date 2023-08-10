//
//  String+CountryCode.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

extension String {
    
    var flag: String? {
        let base : UInt32 = 127397
        var s = ""
        for v in self.unicodeScalars {
            guard let scalar = UnicodeScalar(base + v.value) else { return nil }
            s.unicodeScalars.append(scalar)
        }
        return String(s)
    }

}


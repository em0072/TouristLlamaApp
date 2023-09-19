//
//  String+DetectedAttributedString.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 18/09/2023.
//

import Foundation

extension String {
    var detectedAttributedString: AttributedString {
        
        var attributedString = AttributedString(self)
        
        let types = NSTextCheckingResult.CheckingType.link.rawValue | NSTextCheckingResult.CheckingType.phoneNumber.rawValue
        
        guard let detector = try? NSDataDetector(types: types) else {
            return attributedString
        }
        
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: count))
        
        for match in matches {
            let range = match.range
            let startIndex = attributedString.index(attributedString.startIndex, offsetByCharacters: range.lowerBound)
            let endIndex = attributedString.index(startIndex, offsetByCharacters: range.length)
            // Set the url for links
            if match.resultType == .link, let url = match.url {
                attributedString[startIndex..<endIndex].link = url
                attributedString[startIndex..<endIndex].underlineStyle = .single
                // If it's an email, set the background color
//                if url.scheme == "mailto" {
//                attributedString[startIndex..<endIndex].backgroundColor = .red.opacity(0.3)
//                }
            }
            // Set the url for phone numbers
            if match.resultType == .phoneNumber, let phoneNumber = match.phoneNumber {
                let url = URL(string: "tel:\(phoneNumber)")
                attributedString[startIndex..<endIndex].link = url
                attributedString[startIndex..<endIndex].underlineStyle = .single
            }
        }
        return attributedString
    }
}

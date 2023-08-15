//
//  PexelPhoto.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 11/08/2023.
//

import Foundation

struct PexelPhoto: Codable, Hashable, Identifiable {
    
    enum PhotoAspect {
        case horizontal
        case vertical
    }
        
    let id: Int
    let src: PexelSrc
    let height: Int
    let width: Int
    let photographer: String
    let photographer_url: URL
    let avg_color: String
    
    var aspect: PhotoAspect {
        return height > width ? .vertical : .horizontal
    }
    
    var aspectRatio: CGFloat {
        return CGFloat(height) / CGFloat(width)
    }

    
    struct PexelSrc: Codable, Hashable {
        let original: URL
        let large: URL
        let medium: URL
        let small: URL
        let tiny: URL
        let portrait: URL
        let landscape: URL
    }

}

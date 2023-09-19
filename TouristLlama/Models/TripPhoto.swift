//
//  TripPhoto.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

struct TripPhoto: Equatable, Hashable {
    let small: URL
    let medium: URL
    let large: URL
    
    init(small: URL, medium: URL, large: URL) {
        self.small = small
        self.medium = medium
        self.large = large
    }
    init(url: URL) {
        self.init(small: url, medium: url, large: url)
    }
    
    static var test: TripPhoto {
        TripPhoto(url: URL(string: "https://images.pexels.com/photos/1046216/pexels-photo-1046216.jpeg?auto=compress&cs=tinysrgb&h=130")!)
    }
    
    static var paris: TripPhoto {
        TripPhoto(url: URL(string: "https://images.pexels.com/photos/2363/france-landmark-lights-night.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!)
    }
    
    static var zermatt: TripPhoto {
        TripPhoto(url: URL(string: "https://images.pexels.com/photos/5366524/pexels-photo-5366524.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!)
    }

    static var amsterdam: TripPhoto {
        TripPhoto(url: URL(string: "https://images.pexels.com/photos/4456992/pexels-photo-4456992.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!)
    }

    


}

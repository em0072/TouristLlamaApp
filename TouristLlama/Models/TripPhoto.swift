//
//  TripPhoto.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

struct TripPhoto {
    let small: URL
    let medium: URL
    let large: URL
    
    static var test: TripPhoto {
        TripPhoto(small: URL(string: "https://images.pexels.com/photos/1046216/pexels-photo-1046216.jpeg?auto=compress&cs=tinysrgb&h=130")!,
                  medium: URL(string: "https://images.pexels.com/photos/1046216/pexels-photo-1046216.jpeg?auto=compress&cs=tinysrgb&h=350")!,
                  large: URL(string: "https://images.pexels.com/photos/1046216/pexels-photo-1046216.jpeg?auto=compress&cs=tinysrgb&h=650&w=940")!)
    }
}

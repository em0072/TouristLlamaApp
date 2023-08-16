//
//  User+test.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 15/08/2023.
//

import Foundation

extension User {
    static var test: User {
        User(id: "12345", name: "Bob", email: "bob@mail.com", imageURLString: "https://images.unsplash.com/photo-1563409236302-8442b5e644df?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8ZHVja3xlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80")
    }
    
    static var testNotOwner: User {
        User(id: "3ef", name: "Sam", email: "sam@mail.com", imageURLString: "https://images.pexels.com/photos/209035/pexels-photo-209035.jpeg?cs=srgb&dl=pexels-pixabay-209035.jpg&fm=jpg")
    }

    
    static var testNoPhoto: User {
        User(id: "324rvs", name: "Frodo", email: "frodo@mail.com", imageURLString: nil)
    }
}

//
//  User+test.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 15/08/2023.
//

import Foundation

extension User {
    static var test: User {
        User(id: "12345",
             name: "Bob",
             username: "bob",
             pronoun: .heHim,
             email: "bob@mail.com",
             phone: "0651104950",
             dateOfBirth: nil,
             profilePicture: "https://images.unsplash.com/photo-1563409236302-8442b5e644df?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8ZHVja3xlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80",
             about: "This is 'About me' text. It tells a little bit about me and what I love doing. Alos it explains how I like to travel.",
             memberSince: Date(),
             friends: [])
    }
    
    static var testNotOwner: User {
        User(id: "3ef",
             name: "Sam",
             username: "sam",
             pronoun: .heHim,
             email: "sam@mail.com",
             phone: "0651104950",
             dateOfBirth: nil,
             profilePicture: "https://images.pexels.com/photos/209035/pexels-photo-209035.jpeg?cs=srgb&dl=pexels-pixabay-209035.jpg&fm=jpg",
             about: "About me",
             memberSince: Date(),
             friends: [])
        
    }
    
    
    static var testNoPhoto: User {
        User(id: "324rvs",
             name: "Frodo",
             username: "frodo",
             pronoun: .heHim,
             email: "frodo@mail.com",
             phone: "0651104950",
             dateOfBirth: nil,
             profilePicture: nil,
             about: "About me",
             memberSince: Date(),
             friends: [])
    }
    
    static var testNotInvited: User {
        User(id: "45tges2",
             name: "Random",
             username: "random",
             pronoun: .heHim,
             email: "random@mail.com",
             phone: "09483290234",
             dateOfBirth: nil,
             profilePicture: nil,
             about: "About me",
             memberSince: Date(),
             friends: [])
    }

}

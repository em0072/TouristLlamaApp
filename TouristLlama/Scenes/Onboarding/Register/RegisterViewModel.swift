//
//  RegisterViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import Foundation

class RegisterViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""

    init() {}
    
    var isRegisterButtonDisabled: Bool {
        name.isEmpty || password.isEmpty || !email.isValidEmail 
    }
}

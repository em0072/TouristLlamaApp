//
//  LogInViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import Foundation

class LogInViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
        
    func login() {
        
    }
    
    var isLoginButtonDisabled: Bool {
        !email.isValidEmail || password.isEmpty
    }
}

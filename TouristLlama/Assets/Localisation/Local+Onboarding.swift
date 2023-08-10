//
//  Local+Onboarding.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import Foundation

extension String {
    
    enum Onboarding {
        enum Feature {
            static let findPeople = String.localized("featureFindPeople")
            static let planTrip = String.localized("featurePlanTrip")
        }
        
        static let terms = String.localized("terms")
        static let getStarted = String.localized("getStarted")
        static let quickLogin = String.localized("quickLogin")
        
        static let registerTitle = String.localized("registerTitle")
        static let registerSubtitle = String.localized("registerSubtitle")
        static let register = String.localized("register")
        static let acceptTermsText = String.localized("acceptTermsText")
        
        static let emailConfirmationTitle = String.localized("emailConfirmationTitle")
        static let emailConfirmationSubtitle = String.localized("emailConfirmationSubtitle")
        static let emailConfirmationBody = String.localized("emailConfirmationBody")
        static let emailConfirmationResendPrompt = String.localized("emailConfirmationResendPrompt")
        static let emailConfirmationResendButton = String.localized("emailConfirmationResendButton")

        static let fullName = String.localized("fullName")
        static let email = String.localized("email")
        static let password = String.localized("password")
        
        static let alreadyHaveAccount = String.localized("alreadyHaveAccount")
        static let logIn = String.localized("logIn")
        
        static let loginTitle = String.localized("loginTitle")
        static let forgotPasswordPrompt = String.localized("forgotPasswordPrompt")
        static let noAccountPrompt = String.localized("noAccountPrompt")
        static let signUp = String.localized("signUp")
        
        static let passwordRecoveryTitle = String.localized("passwordRecoveryTitle")
        static let passwordRecoveryBody = String.localized("passwordRecoveryBody")
        static let passwordRecoveryButton = String.localized("passwordRecoveryButton")

    }
    
    private static func localized(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key,
                                           value: nil,
                                           table: "Local+Onboarding")
    }
}

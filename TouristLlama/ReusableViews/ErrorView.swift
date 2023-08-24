//
//  ErrorView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 23/08/2023.
//

import SwiftUI

struct ErrorView: View {
    
    let error: Error?
    
    var body: some View {
        if let error {
            VStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.avenirHeadline)
                    .foregroundColor(.Main.accentRed)
                Text(error.localizedDescription)
                    .font(.avenirBody)
                    .foregroundColor(.Main.black)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: CustomError(text: "Something went wrong. Please try again later."))
    }
}

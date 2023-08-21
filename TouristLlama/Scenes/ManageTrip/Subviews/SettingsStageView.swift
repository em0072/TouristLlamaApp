//
//  SettingsStageView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 14/08/2023.
//

import SwiftUI

struct SettingsStageView: View {
    
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack {
            visibilitySection
         
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

extension SettingsStageView {
    
    private var visibilitySection: some View {
        VStack(alignment: .leading) {
            FieldTitleView(title: String.MyTrips.createTripVisibilityTitle)
                
            Toggle(isOn: $isVisible) {
//                    VStack(alignment: .leading, spacing: 8) {
                        Text(String.MyTrips.createTripVisibilityPrompt)
                            .font(.avenirBody)
//                    }
//                    .padding(.trailing, 25)
            }
            .toggleStyle(SwitchToggleStyle())
            
            Text(String.MyTrips.createTripVisibilityDescription)
                .font(.avenirTagline)

        }
    }
}

struct SettingsStageView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsStageView(isVisible: .constant(true))
    }
}

//
//  DescriptionStageView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 11/08/2023.
//

import SwiftUI

struct DescriptionStageView: View {
    enum FocusField: Hashable {
        case about
    }
    
    @Binding var description: String
        
    var body: some View {
        VStack {
            FramedTextView(title: String.Trips.createTripDescription,
                           prompt: String.Trips.createTripDescriptionPlaceholde,
                           value: $description)
            .frame(height: 300)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

extension DescriptionStageView {
    
}

struct DescriptionStageView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionStageView(description: .constant("value"))
    }
}

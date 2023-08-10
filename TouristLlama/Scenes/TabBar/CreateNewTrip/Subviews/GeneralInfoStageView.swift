//
//  GeneralInfoStageView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct GeneralInfoStageView: View {
    
    @Binding var name: String
    @Binding var tripStyle: TripStyle
    @Binding var tripLocation: TripLocation?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                nameView
                
                stylePickerView
                
                locationPickerView
            }
            .padding(20)
        }
    }
}

extension GeneralInfoStageView {
    private var nameView: some View {
        FramedTextField(title: String.MyTrips.createTripName,
                        prompt: String.MyTrips.createTripNamePlaceholder,
                        value: $name)
    }
    
    private var stylePickerView: some View {
        FramedDataPickerView(title: String.MyTrips.createTripStyle,
                             placeholder: String.MyTrips.createTripStylePlaceholder,
                             selected: $tripStyle,
                             emptyState: TripStyle.none)
    }
    
    private var locationPickerView: some View {
        FramedLocationPickerView(title: String.MyTrips.createTripLocation,
                                 selection: $tripLocation)
    }
}

struct GeneralInfoStageView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralInfoStageView(name: .constant(""),
                             tripStyle: .constant(.none),
                             tripLocation: .constant(nil))
    }
}

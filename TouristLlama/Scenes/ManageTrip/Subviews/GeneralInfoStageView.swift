//
//  GeneralInfoStageView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct GeneralInfoStageView: View {
    
    @Binding var name: String
    @Binding var tripStyle: TripStyle?
    @Binding var tripLocation: TripLocation?
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    
    var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    nameView
                        .padding(.horizontal, 20)

                    stylePickerView
                    
                    locationPickerView
                        .padding(.horizontal, 20)

                    datePickersView
                        .padding(.horizontal, 20)

                }
                .padding(.vertical, 20)
            }
    }
}

extension GeneralInfoStageView {
    private var nameView: some View {
        FramedTextField(title: String.Trips.createTripName,
                        prompt: String.Trips.createTripNamePlaceholder,
                        value: $name)
    }
    
    private var stylePickerView: some View {
        TripStylePicker(title: String.Trips.createTripStyle, selectedStyle: $tripStyle)
    }
    
    private var locationPickerView: some View {
        FramedLocationPickerView(title: String.Trips.createTripLocation,
                                 selection: $tripLocation)
    }
    
    private var datePickersView: some View {
        HStack(spacing: 12) {
            FramedDatePickerView(title: String.Trips.createTripStartDate,
                                 placeholder: String.Trips.createTripDatePlaceholde,
                                 selection: $startDate,
                                 minimumDate: Date(),
                                 maximumDate: endDate)
            
            FramedDatePickerView(title: String.Trips.createTripEndDate,
                                 placeholder: String.Trips.createTripDatePlaceholde,
                                 selection: $endDate,
                                 minimumDate: startDate,
                                 maximumDate: nil)

        }
    }
        
}

struct GeneralInfoStageView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralInfoStageView(name: .constant(""),
                             tripStyle: .constant(nil),
                             tripLocation: .constant(nil),
                             startDate: .constant(Date()),
                             endDate: .constant(nil))
    }
}

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
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    
    var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    nameView
                    
                    stylePickerView
                    
                    locationPickerView
                    
                    datePickersView
                    
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
        FramedPickerView(title: String.MyTrips.createTripStyle,
                             placeholder: String.MyTrips.createTripStylePlaceholder,
                             selected: $tripStyle,
                             emptyState: TripStyle.none)
    }
    
    private var locationPickerView: some View {
        FramedLocationPickerView(title: String.MyTrips.createTripLocation,
                                 selection: $tripLocation)
    }
    
    private var datePickersView: some View {
        HStack(spacing: 12) {
            FramedDatePickerView(title: String.MyTrips.createTripStartDate,
                                 placeholder: String.MyTrips.createTripDatePlaceholde,
                                 selection: $startDate,
                                 minimumDate: Date(),
                                 maximumDate: endDate)
            
            FramedDatePickerView(title: String.MyTrips.createTripEndDate,
                                 placeholder: String.MyTrips.createTripDatePlaceholde,
                                 selection: $endDate,
                                 minimumDate: startDate,
                                 maximumDate: nil)

        }
    }
        
}

struct GeneralInfoStageView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralInfoStageView(name: .constant(""),
                             tripStyle: .constant(.none),
                             tripLocation: .constant(nil),
                             startDate: .constant(Date()),
                             endDate: .constant(nil))
    }
}

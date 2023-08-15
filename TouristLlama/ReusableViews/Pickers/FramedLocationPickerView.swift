//
//  FramedLocationPickerView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct FramedLocationPickerView: View {
    
    let title: String
    @Binding var selection: TripLocation?
    
    @State private var isShowing = false
    
    var body: some View {
        VStack(spacing: 8) {
            FieldTitleView(title: title)
            
            FieldBackgroundView()
                .overlay {
                    pickerView
                }
                .onTapGesture {
                    isShowing.toggle()
                }
            
        }
        .sheet(isPresented: $isShowing, onDismiss: nil) {
            LocationSearchView() { item in
                let location = TripLocation(title: item.title,
                                            country: item.country,
                                            point: item.point,
                                            flag: item.countryCode?.flag)
                selection = location
                isShowing = false
            }
            .presentationDragIndicator(.visible)
        }
    }
}

extension FramedLocationPickerView {
    
    private var pickerView: some View {
        VStack {
            Spacer()
            HStack {
                Text(locationName)
                    .font(.avenirBody.weight(.medium))
                    .foregroundColor(textColor)
                Spacer()
                SelectorIconView()
                    .iconText(textColor)
            }
            Spacer()
        }
        .padding(.horizontal, 10)
    }
    
    private var locationName: String {
        if let location = selection {
            var name = location.title
            if let flag = location.flag {
                name += " "
                name += flag
            }
            return name
        } else {
            return String.MyTrips.createTripLocationPlaceholder
        }
    }
    
    private var textColor: Color {
        isEmpty ? .Main.TLInactiveGrey : .Main.black
    }
    
    private var isEmpty: Bool {
        selection == nil
    }
    
}


struct FramedLocationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        FramedLocationPickerView(title: "Where are you going?", selection: .constant(TripLocation.test))
    }
}

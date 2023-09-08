//
//  TripStylePicker.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 15/08/2023.
//

import SwiftUI

struct TripStylePicker: View {
    
    let title: String
    @Binding var selectedStyle: TripStyle?
    
    var body: some View {
        VStack(spacing: 8) {
            titleView
            
            VStack(spacing: 0) {
                pickerView
                
                if let selectedStyle {
                    HStack {
                        Text(selectedStyle.localizedDescription)
                            .font(.avenirTagline)
                            .foregroundColor(.Main.grey)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .animation(.default, value: selectedStyle)
    }
    
}

extension TripStylePicker {
    private var titleView: some View {
        HStack {
            FieldTitleView(title: title)
        }
        .padding(.horizontal, 20)
    }
    
    private var pickerView: some View {
        ScrollView(axes: .horizontal, showsIndicators: true) {
            HStack {
                ForEach(TripStyle.allCases) { style in
                    styleCell(for: style, selected: selectedStyle == style)
                        .onTapGesture {
                            if selectedStyle == style {
                                selectedStyle = nil
                            } else {
                                selectedStyle = style
                            }
                        }
                }
                .padding(.top, 3)
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func styleCell(for style: TripStyle, selected: Bool) -> some View {
        Label(style.localizedValue, systemImage: style.styleSymbol)
            .font(.avenirSmallBody)
            .foregroundColor(style.styleTextColor)
            .opacity(selected ? 1 : 0.5)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background {
                ZStack {
                    Capsule()
                        .fill(Color.Main.strongWhite.opacity(0.9))
                    
                    Capsule()
                        .fill(style.styleColor)
                        .opacity(selected ? 1 : 0.3)
                    
                    Capsule()
                        .stroke(style.styleColor, lineWidth: 2)
                }
            }
    }
    
}

struct TripStylePicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TripStylePicker(title: String.Trips.createTripStyle, selectedStyle: .constant(.leisure))
            TripStylePicker(title: String.Trips.createTripStyle, selectedStyle: .constant(.active))
            TripStylePicker(title: String.Trips.createTripStyle, selectedStyle: .constant(.cultural))
            TripStylePicker(title: String.Trips.createTripStyle, selectedStyle: .constant(.adventure))
            TripStylePicker(title: String.Trips.createTripStyle, selectedStyle: .constant(.natureAndWildlife))
        }
    }
}

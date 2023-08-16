//
//  MyTripCellView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 15/08/2023.
//

import SwiftUI

struct MyTripsCellView: View {
    
    var trip: Trip
    var isHighlighted: Bool
    
    @State private var isAnimating = false
    
    init(trip: Trip, isHighlighted: Bool = false) {
        self.trip = trip
        self.isHighlighted = isHighlighted
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            tripName
            tripLocation
            tripDates
            HStack(alignment: .bottom) {
                TripParticipantsImagesView(participants: trip.participants)
                Spacer()
                proceedIcon
            }
        }
        .padding(20)
        .contentShape(Rectangle())
        .background {
            cellbackground
        }
        .onAppear {
            isAnimating = isHighlighted
        }
        .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: false), value: isAnimating)
    }
    
}

extension MyTripsCellView {
    
    private var cellbackground: some View {
        ZStack {
            if isHighlighted {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.Main.accentBlue)
                    .scaleEffect(x: isAnimating ? 1.05 : 1, y: isAnimating ? 1.1 : 1)
                    .opacity(isAnimating ? 0 : 0.3)
            }
            
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.Main.TLBackgroundActive)
        }
            
    }
    
    private var tripName: some View {
        Text(trip.name)
            .font(.avenirSubtitle.weight(.heavy))
    }
    
    private var tripLocation: some View {
        Text(trip.location.nameAndFlag)
            .font(.avenirSmallBody.weight(.medium))
            .foregroundColor(.Main.black)
            .opacity(0.8)
    }
    
    
    private var tripDates: some View {
        Text(dateText)
            .font(.avenirSmallBody.weight(.medium))
            .foregroundColor(.Main.black)
            .opacity(0.8)
    }
    
    private var dateText: String {
        if let startDateText = DateHandler().dateToString(trip.startDate),
           let endDateText = DateHandler().dateToString(trip.endDate) {
            return startDateText + " - " + endDateText
        } else {
            return "No trip dates define"
        }
    }
    
    private var proceedIcon: some View {
        ZStack {
            Circle()
                .fill(Color.Main.darkGrey)
                .frame(width: 25, height: 25)
            Image(systemName: "arrow.right")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.Main.TLStrongWhite)
        }
    }
    
}

struct MyTripsCellView_Previews: PreviewProvider {
    static var previews: some View {
        MyTripsCellView(trip: Trip.testFuture, isHighlighted: true)
            .padding(20)
    }
}

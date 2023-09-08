//
//  MyTripCellView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 15/08/2023.
//

import SwiftUI

struct MyTripsCellView: View {
    
    enum Icon {
        case requests
        case chat
    }
    
    let trip: Trip
    let icons: [Icon]
    let isHighlighted: Bool
    
    @State private var isAnimating = false
    
    let onMembersManageOpen: () -> Void
    let onChatOpen: () -> Void

    init(trip: Trip, icons: [Icon], isHighlighted: Bool = false, onMembersManageOpen: @escaping () -> Void, onChatOpen: @escaping () -> Void) {
        self.trip = trip
        self.isHighlighted = isHighlighted
        self.icons = icons
        self.onMembersManageOpen = onMembersManageOpen
        self.onChatOpen = onChatOpen
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleView
            
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
                .onAppear {
                    isAnimating = isHighlighted
                }
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: false), value: isAnimating)
        }
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
    
    private var titleView: some View {
        HStack {
            tripNameView
            
            Spacer()
            
            iconsView
        }
    }
    
    private var tripNameView: some View {
        Text(trip.name)
            .font(.avenirSubtitle)
            .bold()
    }
    
    private var iconsView: some View {
        HStack {
            requestIconView
            chatIconView
        }
    }
    
    @ViewBuilder
    private var requestIconView: some View {
        if icons.contains(.requests) {
            Button {
                onMembersManageOpen()
            } label: {
                Image(systemName: "person.crop.circle.badge.questionmark.fill")
                    .foregroundColor(.Main.yellow)
                    .font(.avenirSubtitle)
            }
        }
    }
    
    @ViewBuilder
    private var chatIconView: some View {
        if icons.contains(.chat) {
            Button {
                onChatOpen()
            } label: {
                Image(systemName: "bubble.left.fill")
                    .foregroundColor(.Main.yellow)
                    .font(.avenirSubtitle)
            }
        }
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
                .foregroundColor(.Main.strongWhite)
        }
    }
    
}

struct MyTripsCellView_Previews: PreviewProvider {
    static var previews: some View {
        MyTripsCellView(trip: Trip.testOngoing, icons: [.chat, .requests], isHighlighted: true, onMembersManageOpen: {}, onChatOpen: {} )
            .padding(20)
    }
}

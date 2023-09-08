//
//  ExploreListCellView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 23/08/2023.
//

import SwiftUI
import Kingfisher

struct ExploreListCellView: View {
    
    @Environment(\.colorScheme) var currentMode

    
    var trip: Trip
    var showBadge: Bool
    
    var body: some View {
        ZStack {
            imageView
            gradientView
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    TripParticipantsImagesView(participants: trip.participants)
                    Spacer()
                    tripStyleView
                }
                Spacer()
                tripNameView
                HStack(alignment: .bottom, spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        tripDatesView
                        tripLocationView
                    }
                    Spacer(minLength: 30)
                    proceedButtonView
                }
            }
            .padding(24)
        }
        .contentShape(Rectangle())
        .cornerRadius(24)
        .frame(height: 330)
    }
    
    private var imageView: some View {
        GeometryReader { proxy in
            KFImage(trip.photo.large)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: proxy.size.width)
        }
    }
    
    @ViewBuilder
    private var tripStyleView: some View {
        if let tripStyle = trip.style {
            ZStack {
                Text(tripStyle.localizedValue)
                    .font(.avenirSmallBody)
                    .bold()
                    .foregroundColor(tripStyle.styleTextColor)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background {
                        Capsule()
                            .fill(tripStyle.styleColor)
                    }
            }
        }
    }
    
    private var tripNameView: some View {
        Text(trip.name)
            .font(.avenirBigBody)
            .bold()
            .foregroundColor(.Main.black)
    }
    
    private var tripDatesView: some View {
        Text(datesText)
            .font(.avenirBody)
            .foregroundColor(.Main.black)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
    }
            
    private var datesText: String {
        guard let start = DateHandler().dateToString(trip.startDate),
              let end = DateHandler().dateToString(trip.endDate) else { return "" }
        return "\(start) - \(end)"
    }

    private var tripLocationView: some View {
        Text(trip.location.nameAndFlag)
            .font(.avenirBody)
            .foregroundColor(.Main.black)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
    }
    
    private var proceedButtonView: some View {
        ZStack {
            Circle()
                .fill(.thinMaterial)
                .environment(\.colorScheme, currentMode == .light ? .dark : .light)
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: "arrow.right")
                        .renderingMode(.template)
                        .foregroundColor(.Main.white)
                }
            if showBadge {
                Circle()
                    .fill(Color.Main.accentRed)
                    .frame(width: 20, height: 20)
                    .offset(x: 15, y: -15)
            }

        }
        
    }
    
}

extension ExploreListCellView {
    
    private var gradientView: some View {
        Rectangle()
            .fill(
                LinearGradient(gradient: Gradient(colors: [.Main.white.opacity(0.9),
                                                           .Main.white.opacity(0.6),
                                                           .clear,
                                                           .clear]),
                               startPoint: .bottom, endPoint: .top)
            )
    }
    
}

struct ExploreListCellView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreListCellView(trip: .testOngoing, showBadge: true)
    }
}

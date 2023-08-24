//
//  ExploreListCellView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 23/08/2023.
//

import SwiftUI
//import Kingfisher

struct ExploreListCellView: View {
    
    var trip: Trip
    
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
            AsyncImage(url: trip.photo.large) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
//            .frame(width: proxy.size.width)
//            .clipped()
        }
    }
    
    @ViewBuilder
    private var tripStyleView: some View {
        if let tripStyle = trip.style {
            ZStack {
                Capsule()
                    .fill(tripStyle.styleColor)
                    .frame(width: 68, height: 33)
                Text(tripStyle.localizedValue)
                    .font(.avenirSmallBody)
                    .bold()
//                    .foregroundColor(tripStyle.)
            }
        }
    }
    
    private var tripNameView: some View {
        Text(trip.name)
            .font(.avenirBigBody)
            .bold()
            .foregroundColor(.Main.TLStrongWhite)
    }
    
    private var tripDatesView: some View {
        Text(datesText)
            .font(.avenirBody)
            .foregroundColor(.Main.TLStrongWhite)
    }
            
    private var datesText: String {
        guard let start = DateHandler().dateToString(trip.startDate),
              let end = DateHandler().dateToString(trip.endDate) else { return "" }
        return "\(start) - \(end)"
    }

    private var tripLocationView: some View {
        Text(trip.location.nameAndFlag)
            .font(.avenirBody)
            .foregroundColor(.Main.TLStrongWhite)
    }
    
    private var proceedButtonView: some View {
        ZStack {
        Circle()
            .fill(Color.Main.TLStrongWhite)
            .frame(width: 40, height: 40)
            Image(systemName: "arrow.right")
                .renderingMode(.template)
                .foregroundColor(.Main.TLStrongBlack)
        }
    }
    
}

extension ExploreListCellView {
    
    private var gradientView: some View {
        Rectangle()
            .fill(
                LinearGradient(gradient: Gradient(colors: [.black.opacity(0.7), .black.opacity(0.4), .clear]),
                               startPoint: .bottom, endPoint: .top)
            )
    }
    
}

struct ExploreListCellView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreListCellView(trip: .testOngoing)
    }
}

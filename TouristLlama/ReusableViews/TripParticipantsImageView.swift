//
//  TripParticipantsImageView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 15/08/2023.
//

import SwiftUI
import Kingfisher

struct TripParticipantsImagesView: View {
    
    let participants: [User]
    
    var body: some View {
        HStack(spacing: 0) {
            let threeOrLess = participants.count <= 3
            let numberOfParticipants = threeOrLess ? participants.count : 2
            ForEach(0..<numberOfParticipants, id: \.self) { i in
                memberCircleImage(imageURL: participants[i].imageURL, position: i)
            }
            if participants.count > 3 {
                let restParticipantsCount = participants.count - 2
                restOfMembersIcon(numberOfMembers: restParticipantsCount)
            }
        }
    }
    
    private func memberCircleImage(imageURL: URL?, position: Int) -> some View {
        KFImage(imageURL)
            .placeholder {
                UserImagePlaceholderView()
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 37, height: 37)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(Color.Main.TLStrongWhite, lineWidth: 2)
            }
            .offset(x: CGFloat(position * 11) * -1)
    }
    
    private func restOfMembersIcon( numberOfMembers: Int) -> some View {
        ZStack {
            Circle()
                .stroke(Color.Main.TLStrongWhite, lineWidth: 2)
                .background(Circle().fill(Color.Main.grey))
                .frame(width: 37, height: 37)
            Text("+\(numberOfMembers)")
                .font(.avenirSmallBody.weight(.heavy))
                .foregroundColor(.Main.TLStrongWhite)
        }
        .offset(x: CGFloat(2 * 11) * -1)
    }
}

struct TripParticipantsImagesView_Previews: PreviewProvider {
    static var previews: some View {
        TripParticipantsImagesView(participants: [User.test, User.testNoPhoto, User.testNoPhoto, User.test])
        
        MyTripsCellView(trip: Trip.testFuture, isHighlighted: true)
            .padding(20)

    }
}


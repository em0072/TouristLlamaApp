//
//  FriendsListCell.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 05/09/2023.
//

import SwiftUI
import Kingfisher

struct FriendsListCell: View {
    
    let user: User
    
    var body: some View {
//        VStack(spacing: 12) {
            HStack(spacing: 15) {
                userImage
                userName
                Spacer()
            }
                
//            Divider()
//        }
//        .padding(.top, 12)
    }
}

extension FriendsListCell {
    private var userImage: some View {
        KFImage(user.imageURL)
            .placeholder({ UserImagePlaceholderView() })
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 35, height: 35)
            .clipShape(Circle())
    }
    
    private var userName: some View {
        Text(user.name)
            .font(.avenirBody)
            .foregroundColor(.Main.black)
    }
    
}

struct FriendsListCell_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListCell(user: .testNotInvited)
    }
}

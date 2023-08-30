//
//  SearchingUsersListCell.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 30/08/2023.
//

import SwiftUI
import Kingfisher

struct SearchingUsersListCell: View {
    
    @Environment(\.isEnabled) var isEnabled
    
    var user: User
    var onSelectAction: () -> ()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                
                profileImageView
                
                VStack(alignment: .leading) {
                    usernameView
                    nameView
                }
                
                Spacer()
                
                selectButtonView
            }
            .padding(.vertical, 12)

            Divider()
        }
    }
    
    private var profileImageView: some View {
        KFImage(user.imageURL)
            .placeholder({ UserImagePlaceholderView() })
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 35, height: 35)
            .clipShape(Circle())
    }
    
    private var usernameView: some View {
        Text(user.username)
            .font(.avenirBody)
            .bold()
            .foregroundColor(.Main.black)
    }
    
    private var nameView: some View {
        Text(user.name)
            .font(.avenirTagline.weight(.medium))
            .lineLimit(1)
            .foregroundColor(.Main.black)
    }
    
    private var selectButtonView: some View {
        Button {
            onSelectAction()
        } label: {
            Text(String.Main.select)
                .font(.avenirBody)
                .foregroundColor(.Main.accentBlue)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.Main.accentBlue, style: .init(lineWidth: 1))
                }
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.4)
    }
}

struct SearchingUsersListCell_Previews: PreviewProvider {
    static var previews: some View {
        SearchingUsersListCell(user: .test) {
            
        }
        .disabled(true)
    }
}

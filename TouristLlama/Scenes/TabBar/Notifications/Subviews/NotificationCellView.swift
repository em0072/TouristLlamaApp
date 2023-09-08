//
//  NotificationCellView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/09/2023.
//

import SwiftUI

struct NotificationCellView: View {
    let notification: UserNotification
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            iconView
            VStack(alignment: .leading, spacing: 6) {
                titleView
                messageView
                dateView
            }
            Spacer()
        }
        .padding(.vertical, 12)

    }
}

extension NotificationCellView {
    private var iconView: some View {
        VStack {
            Image(systemName: notification.icon)
                .font(.system(size: 16))
                .padding(8)
                .background {
                    Circle()
                        .fill(Color.Main.accentBlue.opacity(0.2))
                }
                .overlay {
                    if !notification.read {
                        GeometryReader { proxy in
                            Circle()
                                .fill(Color.Main.accentRed)
                                .frame(width: 15, height: 15)
                                .offset(x: proxy.size.width - 11, y: -3)
                        }
                    }
                }
        }
    }
    
    private var titleView: some View {
        Text(notification.title)
            .font(.avenirBody)
            .bold()
    }
    
    private var messageView: some View {
        Text(notification.mesage)
            .font(.avenirBody)
    }

    @ViewBuilder
    private var dateView: some View {
        if let dateString = notification.created.toString(dateStyle: .medium, timeStyle: .short) {
            Text(dateString)
                .font(.avenirTagline)
                .foregroundColor(.Main.text)
                .opacity(0.6)
        }
    }

}
struct NotificationCellView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCellView(notification: .test)
    }
}

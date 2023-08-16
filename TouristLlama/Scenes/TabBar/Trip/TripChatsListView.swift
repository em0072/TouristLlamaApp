//
//  TripChatsListView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import SwiftUI

struct TripChatsListView: View {
        
        @ObservedObject var viewModel: TripViewModel

        var body: some View {
            VStack {
                emptyView
            }

        }
        
        private var emptyView: some View {
            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .fill(Color.Main.white)
                        .cornerRadius(25, corners: [.topLeft, .topRight, .bottomRight])
                        .frame(width: 184, height: 119)
                        .offset(x: -54, y: -45)
                    Rectangle()
                        .fill(Color.Main.TLBackgroundActive)
                        .cornerRadius(25, corners: [.topLeft, .topRight, .bottomRight])
                        .frame(width: 184 - 10, height: 119 - 10)
                        .offset(x: -54, y: -45)
                    Rectangle()
                        .fill(Color.Main.white)
                        .cornerRadius(25, corners: [.topLeft, .topRight, .bottomLeft])
                        .frame(width: 184, height: 119)
                        .offset(x: 54, y: 45)
                    Rectangle()
                        .fill(Color.Main.TLBackgroundActive)
                        .cornerRadius(25, corners: [.topLeft, .topRight, .bottomLeft])
                        .frame(width: 184 - 10, height: 119 - 10)
                        .offset(x: 54, y: 45)
                }
                .padding(.bottom, 45 + 24)
                Text("Disscuss details of the trip")
                    .foregroundColor(.Main.black)
                    .opacity(0.7)
                    .font(.avenirSubtitle)
                    .bold()
                    .padding(.bottom, 13)
                Text("Create seperate discussions for various topics of the trip")
                    .foregroundColor(.Main.black)
                    .opacity(0.7)
                    .font(.avenirBigBody.weight(.medium))
                Button("Create Discussion") {
                    
                }
                .buttonStyle(WideBlueButtonStyle())
                .padding(.top, 32)
            }
            .padding()
        }

    }

    struct TripChatsListView_Previews: PreviewProvider {
        static var previews: some View {
            TripChatsListView(viewModel: TripViewModel(trip: Trip.testOngoing))
        }
    }

//
//  FeaturesView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import SwiftUI

struct FeaturesView: View {
    @State var selection: Int = 0
    @State var scrollTimer: Timer?
    @State var contentHeight: CGFloat = 0
    
    let features: [FeatureItem]
        
    var body: some View {
        VStack {
            TabView(selection: $selection) {
                ForEach(features) { feature in
                        VStack {
                            Text(feature.title)
                                .font(.avenirSubline)
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.center)
                            
                            feature.view
                        }
                        .padding(.horizontal, 20)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        .onAppear {
            setupTabBar()
        }
    }
    
    private func setupTabBar() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.label
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.secondaryLabel
    }
}

struct FeaturesView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FeaturesView(features: OnboardingFeaturesBuilder().build())
        }
    }
}

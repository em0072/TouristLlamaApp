//
//  OnboardingFeaturesBuilder.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import SwiftUI

class OnboardingFeaturesBuilder {
    
    init() {}
    
    func build() -> [FeatureItem] {
        return Features.allCases.map { $0.featureItem }
    }
    
    fileprivate enum Features: CaseIterable {
        case findPeople
        case planTrip
        
        var featureItem: FeatureItem {
            switch self {
                case .findPeople:
                    return buildFindPeopleFeature()
                case .planTrip:
                    return buildPlanTripFeature()
            }
        }
    }
}

extension OnboardingFeaturesBuilder.Features {
    private func buildFindPeopleFeature() -> FeatureItem {
        return FeatureItem(title: String.Onboarding.Feature.findPeople) {
            Image.Onboarding.welcomeFeature1
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    private func buildPlanTripFeature() -> FeatureItem {
        FeatureItem(title: String.Onboarding.Feature.planTrip) {
            Image.Onboarding.welcomeFeature2
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }

}



struct OnboardingFeaturesBuilder_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            OnboardingFeaturesBuilder.Features.findPeople.featureItem.view
        }
    }
}

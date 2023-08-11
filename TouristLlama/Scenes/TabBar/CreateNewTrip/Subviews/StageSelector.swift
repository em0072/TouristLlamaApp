//
//  TripCreationStageSelector.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 11/08/2023.
//

import SwiftUI

struct StageSelector: View {
    @Environment(\.isEnabled) var isEnabled
    
    let allStages: [TripCreationStage]
    @Binding var currentStage: TripCreationStage
    let allowedStages: Set<TripCreationStage>
    
    var body: some View {
        HStack {
            ForEach(allStages) { stage in
                stageCell(for: stage)
            }
        }
    }
}

extension StageSelector {
    
    private func stageCell(for stage: TripCreationStage) -> some View {
//        ZStack {
        FieldBackgroundView(height: 40, fillColor: isCurrent(stage) ? Color.Main.accentBlue : nil)
            .frame(maxWidth: isCurrent(stage) ? .infinity : 50)
            .overlay {
                if isCurrent(stage) {
                    Text(stage.name)
                        .multilineTextAlignment(.center)
                        .font(.avenirTagline)
                        .foregroundColor(isCurrent(stage) ? .Main.TLStrongWhite : .Main.black)
                        .bold(currentStage == stage)
                        .lineLimit(2)
                } else {
                    stage.icon
                }
            }
            .opacity(isAvailable(stage) ? 1 : 0.5)
            .clipped()
            .onTapGesture {
                if isAvailable(stage) {
                    currentStage = stage
                }
            }
    }

    private func isAvailable(_ stage: TripCreationStage) -> Bool {
        return allowedStages.contains(stage)
    }
    
    private func isCurrent(_ stage: TripCreationStage) -> Bool {
        return currentStage == stage
    }

}

struct StageSelector_Previews: PreviewProvider {
    static var previews: some View {
        StageSelector(allStages: TripCreationStage.allCases,
                      currentStage: .constant(TripCreationStage.description),
                      allowedStages: Set<TripCreationStage>([.generalInfo, .description]))
    }
}

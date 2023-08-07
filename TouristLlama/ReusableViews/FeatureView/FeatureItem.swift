//
//  FeatureItem.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import SwiftUI

struct FeatureItem: Identifiable {
    let id: UUID
    let title: String
    let view: AnyView
    
    init(title: String, @ViewBuilder content: @escaping () -> some View) {
        self.id = UUID()
        self.title = title
        self.view = AnyView(content())
    }
}

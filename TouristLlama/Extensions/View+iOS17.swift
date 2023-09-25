//
//  View+scrollPositionIfPossible.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 19/09/2023.
//

import SwiftUI

extension View {
    func scrollPositionIfPossible(id: Binding<(some Hashable)?>, anchor: UnitPoint?) -> some View {
        if #available(iOS 17.0, *) {
            return self
                .scrollPosition(id: id, anchor: anchor)
        } else {
            return self
        }
    }
    
    func scrollTargetLayoutIfPossible() -> some View {
        if #available(iOS 17.0, *) {
            return self
                .scrollTargetLayout()
        } else {
            return self
        }
    }
    
    func defaultScrollAnchorIfPossible(_ anchor: UnitPoint?) -> some View {
        if #available(iOS 17.0, *) {
            return self
                .defaultScrollAnchor(anchor)
        } else {
            return self
        }
    }

}

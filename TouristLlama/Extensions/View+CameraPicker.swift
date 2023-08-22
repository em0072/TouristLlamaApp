//
//  View+CameraPicker.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 22/08/2023.
//

import SwiftUI

private struct CameraPickerViewModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    @Binding var selection: UIImage?
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                CameraPickerView(image: $selection)
                    .ignoresSafeArea()
            }
    }
    
}

extension View {
    func cameraPicker(isPresented: Binding<Bool>, selection: Binding<UIImage?>) -> some View {
        modifier(CameraPickerViewModifier(isPresented: isPresented, selection: selection))
    }
}

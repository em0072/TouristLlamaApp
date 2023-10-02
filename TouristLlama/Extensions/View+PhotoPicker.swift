//
//  View+PhotoPicker.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 29/09/2023.
//

import SwiftUI
import PhotosUI

private struct PhotoPickerViewModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    @Binding var selection: PhotosPickerItem?
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                    PhotosPicker("Photos", selection: $selection, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared())
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                        .ignoresSafeArea()
            }
    }
    
}

extension View {
    func photoPicker(isPresented: Binding<Bool>, selection: Binding<PhotosPickerItem?>) -> some View {
        modifier(PhotoPickerViewModifier(isPresented: isPresented, selection: selection))
    }
}

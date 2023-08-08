//
//  Error.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import SwiftUI

struct ErrorHadlerViewModifier: ViewModifier {
    
    @Binding var error: Error?
    @Binding var isPresenting: Bool

    func body(content: Content) -> some View {
        content
            .background(
                EmptyView()
                    .alert(isPresented: $isPresenting, content: {
                        Alert(title: Text("Error"), message: Text(error?.localizedDescription ?? "Something went wrong"), dismissButton: .default(Text("OK"), action: {
                            self.error = nil
                        }))
                    })
            )
    }
}


extension View {
    func handle(error: Binding<Error?>) -> some View {
        modifier(ErrorHadlerViewModifier(error: error, isPresenting: .constant(error.wrappedValue != nil ? true : false)))
    }
}


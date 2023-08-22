//
//  FramedTextField.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct FramedTextField: View {
    
    @Environment(\.isEnabled) var isEnabled
        
    let title: String
    let prompt: String?
    @Binding var value: String
    let isLoading: Bool
    let showDeleteButton: Bool
    let textInputAutocapitalization: TextInputAutocapitalization?
    
    init(title: String, prompt: String?, value: Binding<String>, isLoading: Bool = false, showDeleteButton: Bool = true, textInputAutocapitalization: TextInputAutocapitalization? = .sentences) {
        self.title = title
        self.prompt = prompt
        self._value = value
        self.isLoading = isLoading
        self.showDeleteButton = showDeleteButton
        self.textInputAutocapitalization = textInputAutocapitalization
    }

    var body: some View {
        VStack(spacing: 8) {
            if !title.isEmpty {
                FieldTitleView(title: title)
            }
            
            FieldBackgroundView()
                .overlay {
                    textField
                }
        }
    }
}

extension FramedTextField {
            
    @ViewBuilder
    private var textField: some View {
        let promptText = prompt == nil ? nil : Text(prompt!).font(.avenirBody).foregroundColor(.Main.TLInactiveGrey)
        HStack(spacing: 6) {
            TextField("", text: $value, prompt: promptText)
                .textInputAutocapitalization(textInputAutocapitalization)
                .disabled(!isEnabled)
                .opacity(isEnabled ? 1 : 0.5)
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            if showDeleteButton && !value.isEmpty {
                Button {
                    value.removeAll()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .opacity(0.4)
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
}

struct FramedTextField_Previews: PreviewProvider {
    static var previews: some View {
        FramedTextField(title: "Title", prompt: "Prompt", value: .constant("asd"))
            .padding()
    }
    
}

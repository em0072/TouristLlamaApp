//
//  FramedTextField.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct FramedTextField: View {
    
    let title: String
    let prompt: String?
    @Binding var value: String
    let showDeleteButton: Bool
    
    init(title: String, prompt: String?, value: Binding<String>, showDeleteButton: Bool = true) {
        self.title = title
        self.prompt = prompt
        self._value = value
        self.showDeleteButton = showDeleteButton
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
        HStack {
            TextField("", text: $value, prompt: promptText)
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

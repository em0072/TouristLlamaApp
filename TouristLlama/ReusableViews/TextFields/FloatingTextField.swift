//
//  FloatingTextField.swift
//  Tourist Llama
//
//  Created by Evgeny Mitko on 09/02/2022.
//

import SwiftUI
import Combine

struct FloatingTextField: View {
    
    @State private var isShowingSecure: Bool = false
        
    var title: String
    @Binding var value: String
    var foregroundColor: Color?
    var placeholderColorActive: Color = Color(white: 0.3)
    var placeholderColorInactive: Color?
    var keyboardType: UIKeyboardType = .default
    var secure: Bool = false
    

    var body: some View {
            ZStack(alignment: .leading) {
                        Text(title)
                        .foregroundColor(value.isEmpty ? placeholderColorActive : (placeholderColorInactive ?? placeholderColorActive))
                        .opacity(0.8)
                        .offset(y: value.isEmpty ? -5 : -25)
                        .scaleEffect(value.isEmpty ? 1 : 0.8, anchor: .leading)
                HStack {
                    if secure && !isShowingSecure {
                        SecureField("", text: $value)
                            .offset(y: value.isEmpty ? -5 : 0)
                            .foregroundColor(foregroundColor ?? .Main.black)
                            .accentColor(foregroundColor ?? .Main.black)
                            .autocapitalization(.none)
                    } else {
                        TextField("", text: $value)
                            .offset(y: value.isEmpty ? -5 : 0)
                            .foregroundColor(foregroundColor ?? .Main.black)
                            .accentColor(foregroundColor ?? .Main.black)
                            .keyboardType(keyboardType)
                            .autocapitalization(shouldCapitalise() ? .words : .none)
                    }
                    if secure {
                        Button(action: {
                            isShowingSecure.toggle()
                        }) {
                            Image(systemName: self.isShowingSecure ? "eye.slash" : "eye")
                                .accentColor(.gray)
                        }
                        
                    }
                }
            }
            .padding(.top, 15)
            .padding(.bottom, 5)
            .animation(.easeInOut(duration: 0.2), value: value)
    }
    
    private func shouldCapitalise() -> Bool {
        !(keyboardType == .URL || keyboardType == .emailAddress)
    }

}

//MARK: Divider Modifier
struct DividerModifier: ViewModifier {
    
    var color: Color?

    func body(content: Content) -> some View {
        VStack {
            content
            Divider()
                .frame(height: 1)
                .background(color ?? Color.Main.grey.opacity(0.4))
        }
    }
}

extension View {
    func withDivider(colored: Color? = nil) -> some View {
        modifier(DividerModifier())
    }
}

struct FloatingTextField_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTextField(title: "Title", value: .constant("Hello"), secure: true)
            .withDivider()
    }
}

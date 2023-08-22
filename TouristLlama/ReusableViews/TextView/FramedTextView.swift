//
//  FramedTextView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 11/08/2023.
//

import SwiftUI

struct FramedTextView: View {
    
    let title: String
    let prompt: String?
    @Binding var value: String
    let charactersLimit: Int?
    @State private var charactersLeft: Int = 0
    let maxHeight: CGFloat

    init(title: String, prompt: String?, value: Binding<String>, charactersLimit: Int? = nil, maxHeight: CGFloat = 250) {
        self.title = title
        self.prompt = prompt
        self._value = Binding(projectedValue: value)
        self.charactersLimit = charactersLimit
        self.maxHeight = maxHeight
        self._charactersLeft = State(initialValue: charactersLimit ?? 0)
    }

    var body: some View {
        VStack(spacing: 8) {
            if !title.isEmpty {
                FieldTitleView(title: title)
            }
            
            textView
        }
        .onAppear {
            calculateCharectersLeft(for: value)
        }
        .onChange(of: value) { newValue in
            calculateCharectersLeft(for: newValue)
        }
    }
}

extension FramedTextView {
    
    @ViewBuilder
    private var textView: some View {
        ZStack {
            TextEditor(text: $value)
                .font(.avenirBody)
                .padding(7)
                .scrollContentBackground(.hidden)
                .background {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.Main.TLBackgroundActive)
                        
                        promptView
                    }
                }
                .overlay {
                    charectersCountView
                }
                .frame(maxHeight: maxHeight)
        }
    }
}

extension FramedTextView {
    
    private var promptView: some View {
        VStack {
            HStack {
                Text(prompt!)
                    .font(.avenirBody)
                    .foregroundColor(.Main.TLInactiveGrey)
                Spacer()
            }
            Spacer()
        }
        .opacity(value.isEmpty ? 1 : 0)
        .padding(.horizontal, 12)
        .padding(.vertical, 15)
    }
    
    @ViewBuilder
    private var charectersCountView: some View {
        if charactersLimit != nil {
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Text("\(charactersLeft) \(String.Main.charectersLeft)")
                        .font(.avenirCaption)
                        .foregroundColor(.Main.grey)
                }
            }
            .padding(12)
        }
    }
    
    private func calculateCharectersLeft(for newValue: String) {
        if let charactersLimit {
            charactersLeft = charactersLimit - newValue.count
        }
    }
}

struct FramedTextView_Previews: PreviewProvider {
    @State static var viewModel: ManageTripViewModel = .init(mode: .create, onSubmit: nil)
    
    static var previews: some View {
        FramedTextView(title: "Title", prompt: "Prompt", value: .constant("herert1\nsds"), charactersLimit: 300)// $viewModel.tripDescription)
    }
}

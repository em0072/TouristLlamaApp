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
    
    @State private var textHeight: CGFloat = 54

    var body: some View {
        VStack(spacing: 8) {
            if !title.isEmpty {
                FieldTitleView(title: title)
            }
            
            textView
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
                }
        }
    }
}

struct FramedTextView_Previews: PreviewProvider {
    @State static var viewModel: ManageTripViewModel = .init(mode: .create, onSubmit: nil)
    
    static var previews: some View {
        FramedTextView(title: "Title", prompt: "Prompt", value: $viewModel.tripDescription)
    }
}

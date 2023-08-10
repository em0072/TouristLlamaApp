//
//  TermsAndConditionsView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 09/08/2023.
//

import SwiftUI

struct TermsAndConditionsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                titleView
                dateView
                bodyView
            }
            .padding(20)
        }
    }
}

extension TermsAndConditionsView {
    private var titleView: some View {
        Text(String.TermsAndConditions.title)
            .font(.avenirHeadline)
            .bold()
    }
    
    private var dateView: some View {
        HStack(spacing: 0) {
            Text(String.TermsAndConditions.lastUpdated)
            Text(" ")
            Text(String.TermsAndConditions.date)
            Spacer()
        }
        .font(.avenirTagline)
    }
    
    @ViewBuilder
    private var bodyView: some View {
        if let attributedString = try? AttributedString(markdown: String.TermsAndConditions.body, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)) {
            Text(attributedString)
                .font(.avenirBody)
        }
    }
    
    
}

struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditionsView()
    }
}

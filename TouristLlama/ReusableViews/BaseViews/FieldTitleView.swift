//
//  FieldTitleView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct FieldTitleView: View {
    
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.avenirBody)
                .bold()
            Spacer()
        }
    }
}

struct FieldTitleView_Previews: PreviewProvider {
    static var previews: some View {
        FieldTitleView(title: "Title")
    }
}

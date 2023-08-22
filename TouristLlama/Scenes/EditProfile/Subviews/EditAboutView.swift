//
//  EditAboutView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 22/08/2023.
//

import SwiftUI

struct EditAboutView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var about: String

    var body: some View {
        VStack {
            FramedTextView(title: String.Profile.aboutMe, prompt: String.Profile.descriptionPlaceholder, value: $about, charactersLimit: 300)
            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
        .navigationTitle(String.Profile.aboutMe)
//        .toolbar(content: {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                doneButton
//            }
//        })
//        .onAppear {
//            withAnimation(.none) {
//                aboutEditorValue = viewModel.currentUser.about ?? ""
//            }
//        }
//        .track(screenType: self)
    }
    
//    private var doneButton: some View {
//        Button(action: {
//            viewModel.currentUser.about = aboutEditorValue
//            dismiss()
//        }) {
//            Text("Done")
//                .font(.TLBigBody.weight(.heavy))
//        }
//    }
}

struct EditAboutView_Previews: PreviewProvider {
    static var previews: some View {
        EditAboutView(about: .constant("heyt"))
    }
}

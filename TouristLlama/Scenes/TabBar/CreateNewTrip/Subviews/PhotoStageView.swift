//
//  PhotoStageView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 11/08/2023.
//

import SwiftUI
import WaterfallGrid

struct PhotoStageView: View {
    
    let searchQuery: String
    @Binding var tripPhoto: TripPhoto?
    
    var body: some View {
        VStack {
            FieldTitleView(title: String.MyTrips.createTripPhoto)
            
            pexelPhotoPicker
        }
        .padding(.top, 20)
    }
}

extension PhotoStageView {
    
    private var pexelPhotoPicker: some View {
        PexelPhotoPickerView(searchQuery: searchQuery) { pexelPhoto in
            let tripPhoto = TripPhoto(small: pexelPhoto.src.small,
                                      medium: pexelPhoto.src.medium,
                                      large: pexelPhoto.src.large)
            self.tripPhoto = tripPhoto
        }
    }
}

struct PhotoStageViews_Previews: PreviewProvider {
    static var previews: some View {
        PhotoStageView(searchQuery: "Amsterdam", tripPhoto: .constant(nil))
    }
}

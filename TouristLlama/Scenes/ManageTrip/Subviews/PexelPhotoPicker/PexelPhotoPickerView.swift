//
//  PexelPhotoPickerView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 11/08/2023.
//

import SwiftUI
import WaterfallGrid
import Kingfisher

struct PexelPhotoPickerView: View {
    
    @StateObject var viewModel = PexelPhotoPickerViewModel()
    
    let searchQuery: String
    let onPhotoSelection: (PexelPhoto) -> Void
    
    @State private var selectedPhotoId: Int?

    private let numberOfColumns: Int = 2
    private let columnsSpacing: CGFloat = 4
    
    init(searchQuery: String, onPhotoSelection: @escaping (PexelPhoto) -> Void) {
        self.searchQuery = searchQuery
        self.onPhotoSelection = onPhotoSelection
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                    
                    Spacer()
                }
            } else {
                VStack {
                    waterfallGridView
                        .gridStyle(columns: 2, spacing: 4, animation: .default)
                }
                
            }
        }
        .onAppear {
            viewModel.getPhotos(searchQuery: searchQuery)
        }
    }
}

extension PexelPhotoPickerView {
    
    private var waterfallGridView: some View {
        GeometryReader { proxy in
            ScrollView {
                WaterfallGrid(viewModel.photos) { photo in
                    gridCell(for: photo,
                             width: (proxy.size.width / CGFloat(numberOfColumns)) - (CGFloat(numberOfColumns - 1) * columnsSpacing))
                    .onTapGesture {
                        selectedPhotoId = photo.id
                        onPhotoSelection(photo)
                    }
                }
            }
        }
    }
    
    private func gridCell(for photo: PexelPhoto, width: CGFloat) -> some View {
            ZStack {
                imageCellView(photoURL: photo.src.medium)
                    .opacity(selectedPhotoId == photo.id ? 1 : 0.9)
                
                copyrightCellView(photographerName: photo.photographer,
                                  photographerURL: photo.photographer_url)
            }
            .frame(width: width, height: width * photo.aspectRatio)
            .overlay {
                Rectangle()
                    .stroke(selectedPhotoId == photo.id ? Color.Main.accentBlue : .clear,
                            lineWidth: 5)
            }
    }
    
    private func imageCellView(photoURL: URL) -> some View {
        KFImage(photoURL)
            .placeholder {
                Image(systemName: "photo")
                    .font(.avenirSubline)
                    .foregroundColor(Color.Main.TLInactiveGrey)
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    private func copyrightCellView(photographerName: String, photographerURL: URL) -> some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Link("© \(photographerName)", destination: photographerURL)
                    .font(.avenirCaption)
                    .padding(.horizontal, 5)
                    .background {
                        Capsule()
                            .fill(Color.Main.TLBackground.opacity(0.5))
                    }
                    .padding(3)
            }
        }
    }
}

struct PexelPhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PexelPhotoPickerView(searchQuery: "Amsterdam") { _ in }
    }
}

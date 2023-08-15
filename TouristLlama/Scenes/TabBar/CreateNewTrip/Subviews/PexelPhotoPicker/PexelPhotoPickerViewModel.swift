//
//  PexelPhotoPickerViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 11/08/2023.
//

import Foundation
import Dependencies

@MainActor
class PexelPhotoPickerViewModel: ViewModel {
    
    @Dependency(\.pexelService) var pexelService
    
    @Published var photos = [PexelPhoto]()
    @Published var isLoading: Bool = true
    
    func getPhotos(searchQuery: String) {
        isLoading = true
        Task {
            try await Task.sleep(for: .seconds(0.3))
            do {
                photos = try await pexelService.getPhotos(query: searchQuery)
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
}

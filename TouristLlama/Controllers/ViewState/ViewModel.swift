//
//  ViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import SwiftUI
import Combine

@MainActor
class ViewModel: ObservableObject {
    
    enum ViewState {
        case loading
        case content
        case error
    }
        
    @Published var loadingState: LoadingState = .none
    @Published var error: Error? {
        didSet {
            loadingState = .none
        }
    }
    @Published var state: ViewState = .loading
    
    var publishers = [AnyCancellable]()
    
    init() {
        subscribeToUpdates()
    }
    
    func cancelPublishers() {
        publishers.forEach({$0.cancel()})
    }
    
    func subscribeToUpdates() {
        
    }
    
    func unsubscribeFromUpdates() {
        cancelPublishers()
    }
}

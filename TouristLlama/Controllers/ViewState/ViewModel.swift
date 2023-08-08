//
//  ViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject {
        
    @Published var loadingState: LoadingState = .none
    @Published var error: Error? {
        didSet {
            loadingState = .none
        }
    }
    
    var publishers = [AnyCancellable]()
    
    init() {}
    
    func cancelPublishers() {
        publishers.forEach({$0.cancel()})
    }
    
    func subscribeToUpdates() {
        
    }
    
    func unsubscribeFromUpdates() {
        cancelPublishers()
    }
}

//
//  Loading.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import SwiftUI
import AlertToast

class LoadHandling: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var isError: Bool = false
    @Published var error: Error? {
        didSet {
            isError = error != nil
        }
    }

    func set(state: Bool) {
        guard isLoading != state else { return }
        DispatchQueue.main.async {
            self.isLoading = state
        }
    }
    
    func on() {
        self.set(state: true)
    }
    
    func off() {
        self.set(state: false)
    }
    
    func showSuccess() {
        DispatchQueue.main.async {
            self.off()
            self.isSuccess = true
        }
    }
    
    func showError(_ error: Error) {
        DispatchQueue.main.async {
            self.off()
            self.error = error
        }
    }
    
}

struct HandleLoadingByShowingIndicatorViewModifier: ViewModifier {
    @StateObject var loader = LoadHandling()

    func body(content: Content) -> some View {
        content
            .disabled(loader.isLoading)
            .environmentObject(loader)
                    .toast(isPresenting: $loader.isLoading, alert: {
                        AlertToast(displayMode: .alert, type: .loading)
                    })
                    .toast(isPresenting: $loader.isSuccess, alert: {
                        AlertToast(displayMode: .alert, type: .complete(.Main.TLGreen))
                    })
                    .toast(isPresenting: $loader.isError) {
                        AlertToast(displayMode: .alert, type: .error(.Main.accentRed), title: loader.error?.localizedDescription)
                    }
    }
}

extension View {
    func withLoader() -> some View {
        modifier(HandleLoadingByShowingIndicatorViewModifier())
    }
}

enum LoadingState: Equatable {
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
    
    case none
    case loading
    case success
    case error(Error)
}


struct LoadHadlerViewModifier: ViewModifier {
    
    @StateObject var loader = LoadHandling()
    @Binding var state: LoadingState

    func body(content: Content) -> some View {
        content
            .onChange(of: state, perform: { state in
                switch state {
                case .none:
                    loader.off()
                case .loading:
                    loader.on()
                case .success:
                    loader.showSuccess()
                case .error(let error):
                    loader.showError(error)
                }
            })
            .toast(isPresenting: $loader.isLoading, alert: {
                AlertToast(displayMode: .alert, type: .loading)
            })
            .toast(isPresenting: $loader.isSuccess, alert: {
                AlertToast(displayMode: .alert, type: .complete(.Main.TLGreen))
            })
            .toast(isPresenting: $loader.isError) {
                AlertToast(displayMode: .alert, type: .error(.Main.accentRed), title: loader.error?.localizedDescription)
            }
        
    }
}


extension View {
    func handle(loading: Binding<LoadingState>) -> some View {
            modifier(LoadHadlerViewModifier(state: loading))
    }
}

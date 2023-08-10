//
//  LocationSearchViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation
import MapKit
import Combine

final class LocationSearchViewModel: ViewModel {
    
    @Published var searchText = "" {
        didSet {
            isShowingActivityIndicator = searchText.isEmpty ? false : true
        }
    }
            
    @Published var isShowingActivityIndicator: Bool = false
    @Published var viewData = [LocationCompletionViewData]()
    @Published var selectedItem: LocationSearchViewData?
    
    let service: LocationSearch
    
    override init() {
        service = LocationSearch()
        super.init()
    }
    
    override func subscribeToUpdates() {
        service.completerResults
            .sink { [weak self] items in
                guard let self else { return }
                self.isShowingActivityIndicator = false
                self.viewData = items.map({ LocationCompletionViewData(completion: $0) })
            }
            .store(in: &publishers)

        $searchText
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                guard let self else { return }
                service.search(searchText)
            }
            .store(in: &publishers)
    }
    
    func requestMapItem(with searchCompletion: MKLocalSearchCompletion, completion: @escaping (Result<LocationSearchViewData, Error>) -> ()) {
        let request = MKLocalSearch.Request(completion: searchCompletion)
        request.resultTypes = .address
        service.search(using: request) { result in
            switch result {
            case .success(let item):
                let resultItem = LocationSearchViewData(mapItem: item)
                completion(.success(resultItem))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func onListItemSelect(item: MKLocalSearchCompletion) {
        self.loadingState = .loading
        requestMapItem(with: item) { [weak self] result in
            guard let self else { return }
            self.loadingState = .none
            switch result {
            case .success(let mapItem):
                self.selectedItem = mapItem
                
            case .failure(let error):
                self.error = error
            }
        }
    }

}

struct LocationCompletionViewData: Identifiable {
    let id = UUID()
    let title: String
    let attributedTitle: AttributedString
    let subtitle: String
    let attributedSubtitle: AttributedString
    let completion: MKLocalSearchCompletion
        
    init(completion: MKLocalSearchCompletion) {
        self.title = completion.title
        var attributedTitle = AttributedString(completion.title)
        attributedTitle.font = .avenirBody
        attributedTitle.foregroundColor = .Main.TLText
        for value in completion.titleHighlightRanges {
            let range = value.rangeValue
            guard let titleRange = Range(range, in: attributedTitle) else { continue }
            attributedTitle[titleRange].font = .avenirBody.weight(.black)
        }
        self.attributedTitle = attributedTitle
        
        self.subtitle = completion.subtitle
        var attributedSubtitle = AttributedString(completion.subtitle)
        attributedSubtitle.font = .avenirSmallBody
        attributedSubtitle.foregroundColor = .Main.TLText
        for value in completion.subtitleHighlightRanges {
            let range = value.rangeValue
            guard let subtitleRange = Range(range, in: attributedSubtitle) else { continue }
            attributedSubtitle[subtitleRange].font = .avenirSmallBody.weight(.black)
        }
        self.attributedSubtitle = attributedSubtitle

        self.completion = completion
    }
}

struct LocationSearchViewData: Identifiable, Equatable {
    
    let id: UUID
    let title: String
    let city: String
    let country: String
    let point: CLLocation?
    let region: CLRegion?
    let countryCode: String?
    
    init(mapItem: MKMapItem) {
        self.id = UUID()
        self.title = mapItem.placemark.title ?? ""
        self.country = mapItem.placemark.country ?? ""
        self.city = mapItem.placemark.country == mapItem.name ? "" : mapItem.name ?? ""
        if let coordinate = mapItem.placemark.location?.coordinate {
            self.point = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        } else {
            self.point = nil
        }
        self.region = mapItem.placemark.region
        self.countryCode = mapItem.placemark.countryCode
    }

}

//
//  LocationSearch.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation
import Combine
import MapKit

class LocationSearch: NSObject, MKLocalSearchCompleterDelegate  {
    
    var searchQuery = ""
    var completer: MKLocalSearchCompleter = MKLocalSearchCompleter()
    let completerResults = PassthroughSubject<[MKLocalSearchCompletion], Never>()

    private var search: MKLocalSearch?

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
    }
    
    public func search(_ searchText: String) {
        self.searchQuery = searchText
        completer.queryFragment = searchText
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.completerResults.send(completer.results)
    }
    
    func search(using searchRequest: MKLocalSearch.Request, completion: @escaping (Result<MKMapItem, Error>) -> () ) {
        search?.cancel()
        search = MKLocalSearch(request: searchRequest)
        guard let search = search else { return }
        
        search.start { response, error in
            if let error = error {
                completion(.failure(error))
            } else if let item = response?.mapItems.first {
                completion(.success(item))
            }
        }
    }
}

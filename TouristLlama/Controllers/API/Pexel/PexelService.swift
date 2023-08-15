//
//  PexelService.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 11/08/2023.
//

import Foundation
import Alamofire

class PexelService {

    init(){}
    
    private var header: HTTPHeaders {
        ["Authorization": PexelConst.apiKey]
    }
        
    func getPhotos(query: String) async throws -> [PexelPhoto] {
        let data = try await AF.request("https://api.pexels.com/v1/search", method: .get, parameters: ["query": query, "per_page": 50], headers: self.header)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .serializingData()
            .value
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let photosArray = json?["photos"] ?? [String: Any]()
        let jsonData = try JSONSerialization.data(withJSONObject: photosArray)
        let photos = try JSONDecoder().decode([PexelPhoto].self, from: jsonData)
        return photos
    }
    
}

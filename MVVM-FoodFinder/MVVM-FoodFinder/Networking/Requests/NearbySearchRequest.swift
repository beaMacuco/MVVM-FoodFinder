//
//  NearbySearchRequest.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 19/07/23.
//

import Foundation
import CoreLocation

protocol SearchRequest {
    func fetch(by location: CLLocation) async throws -> [Place]
}

struct NearbySearchRequest: SearchRequest {
    private static let radius = 5000
    private let googleApiRequest: Networking
    
    init(googleApiRequest: Networking = GoogleRequestDecorator()) {
        self.googleApiRequest = googleApiRequest
    }
    
    func fetch(by location: CLLocation) async throws -> [Place] {
        let urlString = makeEndpoint(from: location)
        let data: Data = try await googleApiRequest.request(from: urlString)
        let places: [Place] = try googleApiRequest.decode(from: data)
        
        return places
    }
    
    private func makeEndpoint(from location: CLLocation) -> String {
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.coordinate.latitude),\(location.coordinate.longitude)&type=restaurant&radius=\(Self.radius)"
    }
}

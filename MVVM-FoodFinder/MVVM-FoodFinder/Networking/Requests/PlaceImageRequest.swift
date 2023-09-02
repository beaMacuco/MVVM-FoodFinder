//
//  PlaceImageRequest.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 18/08/23.
//

import Foundation

protocol ImageRequest {
    func fetch(by reference: String) async throws -> Data
}

struct PlaceImageRequest: ImageRequest {
    private let googleRequest: Networking
    
    init(googleRequest: Networking = GoogleRequestDecorator()) {
        self.googleRequest = googleRequest
    }

    func fetch(by reference: String) async throws -> Data {
        let urlString = makeUrl(from: reference)
        let data = try await googleRequest.request(from: urlString)
        
        return data
    }
    
    private func makeUrl(from identifier: String) -> String {
        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photo_reference=\(identifier)"
    }
}

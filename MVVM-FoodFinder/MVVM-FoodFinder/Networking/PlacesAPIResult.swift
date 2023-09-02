//
//  PlacesAPIResult.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 19/07/23.
//

import Foundation
import CoreLocation

struct GoogleApiResults<T: Codable>: Codable {
    let results: T
    let status: String
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case results
        case status
        case errorMessage = "error_message"
    }
}

struct OpeningHours: Codable {
    let openNow: Bool?
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

struct Geometry: Codable {
    let location: LatLngLiteral
}

struct LatLngLiteral: Codable {
    let lat: Double
    let lng: Double
}

struct PlacePhoto: Codable {
    let reference: String
    
    enum CodingKeys: String, CodingKey {
        case reference = "photo_reference"
    }
}

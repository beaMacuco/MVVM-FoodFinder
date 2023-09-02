//
//  PlacesAPIResult.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 19/07/23.
//

import Foundation

struct GooglePlacesAPIResults: Codable {
    let results: [GooglePlacesAPIResult]
}

struct GooglePlacesAPIResult: Codable {
    let businessStatus: String
    let geometry: Geometry
    let name: String
    let openingHours: OpeningHours
    let placeId: String
    let priceLevel: Int
    let rating: Int
}

struct Geometry: Codable {
    let location: [Double: Double]
}

struct OpeningHours: Codable {
    let openNow: Bool
}

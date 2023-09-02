//
//  PlaceMock.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 29/08/23.
//

import Foundation

struct PlaceMock {
    static let id = "12345"

    static func makePlaces(_ photos: [PlacePhoto]? = nil) -> [Place] {
        [Self.makePlace(photos)]
    }
    
    static func makePlace(_ photos: [PlacePhoto]? = nil) -> Place {
        Place(photos: photos, geometry: Geometry(location: LatLngLiteral(lat: 22.9, lng: 88.6)), id: Self.id, businessStatus: "operational", name: "test name", openingHours: OpeningHours(openNow: true), priceLevel: 5, rating: 2, address: "some address")
    }
}

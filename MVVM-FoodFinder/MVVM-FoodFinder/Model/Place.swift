//
//  Place.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 23/08/23.
//

import Foundation
import CoreLocation

struct Place: Codable {
    private let photos: [PlacePhoto]?
    private let geometry: Geometry?
    let id: String
    let businessStatus: String?
    let name: String?
    let openingHours: OpeningHours?
    let priceLevel: Int?
    let rating: Double?
    let address: String?
    
    var photoReference: String? {
        photos?.first?.reference
    }
    
    var location: LatLngLiteral? {
        guard let latitude = geometry?.location.lat,
              let longitude = geometry?.location.lng else {
            return nil
        }
        return LatLngLiteral(lat: latitude, lng: longitude)
    }
    
    init(photos: [PlacePhoto]?, geometry: Geometry?, id: String, businessStatus: String?, name: String?, openingHours: OpeningHours?, priceLevel: Int?, rating: Double?, address: String?) {
        self.photos = photos
        self.geometry = geometry
        self.id = id
        self.businessStatus = businessStatus
        self.name = name
        self.openingHours = openingHours
        self.priceLevel = priceLevel
        self.rating = rating
        self.address = address
    }
    
    enum CodingKeys: String, CodingKey {
        case address = "vicinity"
        case id = "place_id"
        case businessStatus = "business_status"
        case name
        case openingHours = "opening_hours"
        case priceLevel =  "price_level"
        case rating
        case photos
        case geometry
    }
}

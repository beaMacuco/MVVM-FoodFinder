//
//  PlaceViewModel.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 29/07/23.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
final class PlaceViewModel: ObservableObject {
    @Published private(set) var place: Place
    @Published private(set) var image: Image?
    private let googleMaps: GoogleMaps = GoogleMaps()
    private let imageFetcher: ImageFetchable

    var name: String? {
        place.name
    }
    
    var address: String? {
        place.address
    }
    
    var mapURL: URL? {
        guard let lat = place.location?.lat, let lang = place.location?.lng else {
            return nil
        }
        return URL(string: googleMaps.getMapURL(at: lat, lang))
    }
    
    var rating: String? {
        guard let rating = place.rating else {
            return nil
        }
        return "\(StaticViewValues.LocalisableStrings.rating): \(String(repeating: Symbols.Emoji.rating, count: Int(rating)))"
    }
    
    var priceLevel: String? {
        guard let priceLevel = place.priceLevel else {
            return nil
        }
        return "\(StaticViewValues.LocalisableStrings.priceLevel) \(String(repeating: Symbols.Emoji.priceLevel, count: priceLevel))"
    }
    
    var isOpen: String? {
        guard let isOpen = place.openingHours?.openNow else {
            return nil
        }
        
        return "\(Symbols.Emoji.isOpen)"
    }
    
    init(place: Place, imageFetcher: ImageFetchable = ImageFetcher()) {
        self.place = place
        self.imageFetcher = imageFetcher
    }
    
    func fetchImage() {
        Task {
            guard let reference = place.photoReference else {
                return
            }
            image = try await imageFetcher.fetchImage(from: reference)
        }
    }
}

extension PlaceViewModel {
    static func make(for place: Place) -> PlaceViewModel {
        PlaceViewModel(place: place)
    }
}

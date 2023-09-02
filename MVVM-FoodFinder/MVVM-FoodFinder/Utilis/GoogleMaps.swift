//
//  OpenGoogleMaps.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 19/08/23.
//

import UIKit

struct GoogleMaps {
    func getMapURL(at latitude: Double, _ longitude: Double) -> String {
        "https://www.google.com/maps/@\(latitude),\(longitude),6z"
    }
}

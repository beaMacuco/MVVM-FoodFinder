//
//  CLLLocationManager+CoreLocationManager.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 19/07/23.
//

import Foundation
import CoreLocation

extension CLLocationManager: CoreLocationManager {

    var locationManagerDelegate: CoreLocationManagerDelegate? {
        get {
            delegate as? CoreLocationManagerDelegate
        }
        set {
            delegate = newValue as? CLLocationManagerDelegate
        }
    }
}

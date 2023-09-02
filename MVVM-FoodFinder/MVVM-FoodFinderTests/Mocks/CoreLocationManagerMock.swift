//
//  CoreLocationManagerMock.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 29/08/23.
//

import Foundation
import CoreLocation

enum LocationErrorMock: Error {
    case failedToSendUpdate
}

class CoreLocationManagerMock: CoreLocationManager {
    var authorizationRequested: Bool = false
    
    var locationRequested: Bool = false
    
    var locationManagerDelegate: CoreLocationManagerDelegate?
    
    var pausesLocationUpdatesAutomatically: Bool = false
    
    var desiredAccuracy: CLLocationAccuracy = .nan
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    func requestWhenInUseAuthorization() {
        authorizationRequested = true
    }
    
    func requestLocation() {
        locationRequested = true
    }
}

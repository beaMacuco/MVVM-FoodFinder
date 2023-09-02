//
//  CoreLocationManager.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 19/07/23.
//
import Foundation
import CoreLocation

protocol CoreLocationManager {
    var locationManagerDelegate: CoreLocationManagerDelegate? { get set }
    var pausesLocationUpdatesAutomatically: Bool { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func requestWhenInUseAuthorization()
    func requestLocation()
}

extension CoreLocationManager {
    var isLocationMonitoringAuthorized: Bool {
        authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
    }
}

protocol CoreLocationManagerDelegate {
    func coreLocationManagerDidChangeAuthorization(_ manager: CoreLocationManager)
    func coreLocationManager(_ manager: CoreLocationManager, didUpdateLocations locations: [CLLocation])
    func coreLocationManager(_ manager: CoreLocationManager, didFailWithError error: Error)
}

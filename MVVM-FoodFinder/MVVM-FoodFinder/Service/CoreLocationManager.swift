//
//  CoreLocationManager.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 19/07/23.
//
import Foundation
import CoreLocation

protocol CoreLocationManager {
    var location: CLLocation? { get }
    var locationManagerDelegate: CoreLocationManagerDelegate? { get set }
    var distanceFilter: CLLocationDistance { get set }
    var pausesLocationUpdatesAutomatically: Bool { get set }
    var allowsBackgroundLocationUpdates: Bool { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    var activityType: CLActivityType { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func requestAlwaysAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

extension CoreLocationManager {
    var isLocationMonitoringAuthorized: Bool {
        authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
    }
}

protocol CoreLocationManagerDelegate {
    func locationManagerDelegate(_ manager: CoreLocationManager, didUpdateLocations locations: [CLLocation])
    func locationManagerDelegateDidChangeAuthorization(_ manager: CoreLocationManager)
}

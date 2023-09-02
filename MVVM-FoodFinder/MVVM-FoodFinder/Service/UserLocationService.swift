//
//  UserLocationService.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 19/07/23.
//

import Foundation
import CoreLocation
import Combine

protocol LocationService {
    var location: PassthroughSubject<CLLocation, Error> { get }
    var isAuthorized: CurrentValueSubject<Bool, Never>  { get }
    func setUp()
    func requestLocation()
}

final class UserLocationService: NSObject, LocationService {
    private(set) var locationManager: CoreLocationManager
    private(set) var isAuthorized: CurrentValueSubject<Bool, Never>
    private(set) var location: PassthroughSubject<CLLocation, Error>
    
    init(locationManager: CoreLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        self.isAuthorized = CurrentValueSubject<Bool, Never>(locationManager.isLocationMonitoringAuthorized)
        self.location = PassthroughSubject<CLLocation, Error>()
    }
    
    func setUp() {
        configureLocation()
    }
    
    private func configureLocation() {
        locationManager.locationManagerDelegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}

extension UserLocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coreLocationManager(manager, didUpdateLocations: locations)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        coreLocationManagerDidChangeAuthorization(manager)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coreLocationManager(manager, didFailWithError: error)
    }
}

extension UserLocationService: CoreLocationManagerDelegate {
    
    func coreLocationManagerDidChangeAuthorization(_ manager: CoreLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized.send(true)
        case .restricted, .denied:
            isAuthorized.send(false)
        case .notDetermined:
            isAuthorized.send(false)
            locationManager.requestWhenInUseAuthorization()
        default:
            isAuthorized.send(false)
        }
    }
    
    func coreLocationManager(_ manager: CoreLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        location.send(currentLocation)
    }
    
    func coreLocationManager(_ manager: CoreLocationManager, didFailWithError error: Error) {
        location.send(completion: .failure(error))
    }
}

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
    func setUp()
    func startMonitoring()
    func stopMonitoring()
    var location: PassthroughSubject<CLLocation?, Never> { get }
    var isAuthorized: CurrentValueSubject<Bool, Never> { get }
}

final class UserLocationService: NSObject, LocationService, ObservableObject {
    private let minimumDistance = 100.0
    private(set) var previousLocation: CLLocation?
    private(set) var currentLocation: CLLocation?
    private var cancellables = Set<AnyCancellable>()
    private(set) var locationManager: CoreLocationManager
    private(set) var location = PassthroughSubject<CLLocation?, Never>()
    private(set) var isAuthorized: CurrentValueSubject<Bool, Never>
    
    init(locationManager: CoreLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        self.isAuthorized = CurrentValueSubject<Bool, Never>(locationManager.isLocationMonitoringAuthorized)
        super.init()
    }
    
    func setUp() {
        configureLocation()
    }
    
    private func configureLocation() {
        locationManager.locationManagerDelegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
    }
    
    func startMonitoring() {
        locationManager.startUpdatingLocation()
    }
    
    func stopMonitoring() {
        locationManager.stopUpdatingLocation()
        resetLocation()
    }
    
    private func resetLocation() {
        previousLocation = nil
        currentLocation = nil
    }
    
    private func isDistanceEqualToOrHigherThanMinimumDistance(location: CLLocation) -> Bool {
        guard let previousLocation = previousLocation else {
            return true
        }
        return previousLocation.distance(from: location) >= minimumDistance
    }
}

extension UserLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coreLocationManager(manager, didUpdateLocations: locations)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        coreLocationManagerDidChangeAuthorization(manager)
    }
}

extension UserLocationService: CoreLocationManagerDelegate {
    
    func coreLocationManager(_ manager: CoreLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastestLocation = locations.last,
              isDistanceEqualToOrHigherThanMinimumDistance(location: lastestLocation) else {
            return
        }
        let previous = currentLocation
        currentLocation = lastestLocation
        previousLocation = previousLocation == nil ? currentLocation : previous
        location.send(currentLocation)
    }
    
    func coreLocationManagerDidChangeAuthorization(_ manager: CoreLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized.send(true)
        case .restricted, .denied:
            isAuthorized.send(false)
        case .notDetermined:
            isAuthorized.send(false)
            locationManager.requestAlwaysAuthorization()
        default: break
        }
    }
}

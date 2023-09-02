//
//  LocationServiceMock.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 29/08/23.
//

import Foundation
import Combine
import CoreLocation

class LocationServiceMock: LocationService {
    var setupWasCalled: Bool = false
    var requestLocationWasCalled: Bool = false
    var location: PassthroughSubject<CLLocation, Error> = PassthroughSubject<CLLocation, Error>()
    var isAuthorized: CurrentValueSubject<Bool, Never>  = CurrentValueSubject<Bool, Never>(false)
    
    func setUp() {
        setupWasCalled = true
    }
    
    func requestLocation() {
        requestLocationWasCalled = true
    }
}

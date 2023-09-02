//
//  UserLocationServiceTests.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 29/08/23.
//

import XCTest
import CoreLocation
import Combine
@testable import MVVM_FoodFinder

class UserLocationServiceTests: XCTestCase {
    private var sut: UserLocationService!
    private var locationManager: CoreLocationManagerMock!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        locationManager = CoreLocationManagerMock()
        sut = UserLocationService(locationManager: locationManager)
    }
    
    func test_WhenSetupIsCalled_ThenLocationManagerDelegateIsSet() {
        XCTAssertNil(locationManager.locationManagerDelegate)
        sut.setUp()
        XCTAssertNotNil(locationManager.locationManagerDelegate)
    }
    
    func test_WhenSetupIsCalled_ThenRequestWhenInUseAuthorizationIsSent() {
        XCTAssertFalse(locationManager.authorizationRequested)
        sut.setUp()
        XCTAssertTrue(locationManager.authorizationRequested)
    }
    
    func test_WhenSetupIsCalled_ThenPausesLocationUpdatesAutomaticallyIsTrue() {
        XCTAssertFalse(locationManager.pausesLocationUpdatesAutomatically)
        sut.setUp()
        XCTAssertTrue(locationManager.pausesLocationUpdatesAutomatically)
    }
    
    func test_WhenSetupIsCalled_ThenDesiredAccuracyIsSetToBest() {
        XCTAssertFalse(locationManager.desiredAccuracy == kCLLocationAccuracyBest)
        sut.setUp()
        XCTAssertTrue(locationManager.desiredAccuracy == kCLLocationAccuracyBest)
    }
    
    func test_WhenRequestLocationIsCalled_ThenLocationManagerWillRequestLocation() {
        XCTAssertFalse(locationManager.locationRequested)
        sut.requestLocation()
        XCTAssertTrue(locationManager.locationRequested)
    }
    
    func test_WhenAuthorizationIsAlways_ThenAuthorizedIsTrue() {
        locationManager.authorizationStatus = .authorizedAlways
        sut.coreLocationManagerDidChangeAuthorization(locationManager)
        
        XCTAssertTrue(sut.isAuthorized.value)
    }
    
    func test_WhenAuthorizationIsWhenInUse_ThenAuthorizedIsTrue() {
        locationManager.authorizationStatus = .authorizedWhenInUse
        sut.coreLocationManagerDidChangeAuthorization(locationManager)
        
        XCTAssertTrue(sut.isAuthorized.value)
    }
    
    func test_WhenAuthorizationIsDenied_ThenAuthorizedIsFalse() {
        locationManager.authorizationStatus = .denied
        sut.coreLocationManagerDidChangeAuthorization(locationManager)
        
        XCTAssertFalse(sut.isAuthorized.value)
    }
    
    func test_WhenAuthorizationIsRestricted_ThenAuthorizedIsFalse() {
        locationManager.authorizationStatus = .restricted
        sut.coreLocationManagerDidChangeAuthorization(locationManager)
        
        XCTAssertFalse(sut.isAuthorized.value)
    }
    
    func test_WhenAuthorizationIsNotDetermined_ThenAuthorizedIsFalse() {
        locationManager.authorizationStatus = .notDetermined
        sut.coreLocationManagerDidChangeAuthorization(locationManager)
        
        XCTAssertFalse(sut.isAuthorized.value)
    }
    
    func test_WhenAuthorizationIsNotDetermined_ThenAuthorizationRequestIsSent() {
        locationManager.authorizationStatus = .notDetermined
        sut.coreLocationManagerDidChangeAuthorization(locationManager)
        
        XCTAssertTrue(locationManager.authorizationRequested)
    }
    
    func test_WhenLocationManagerSendsLocationUpdates_ThenLocationIsUpdated() {
        let expected = CLLocation(latitude: -34.1, longitude: 102.6)
        
        sut.location
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail("failed with \(error)")
                }
            } receiveValue: { location in
                XCTAssertEqual(location, expected)
            }
            .store(in: &cancellables)
        
        sut.coreLocationManager(locationManager, didUpdateLocations: [expected])
    }
    
    func test_WhenLocationManagerFailsToSendUpdates_ThenLocationReceivesError() {
        let expected: LocationErrorMock = .failedToSendUpdate
        
        sut.location
            .sink { completion in
                guard case .failure(let error) = completion, let error = error as? LocationErrorMock else {
                    XCTFail("should have received error")
                    return
                }
                XCTAssertEqual(expected, error)
                
            } receiveValue: { location in }
            .store(in: &cancellables)
        
        sut.coreLocationManager(locationManager, didFailWithError: expected)
    }
}

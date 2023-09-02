//
//  PlacesViewModelTests.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 29/08/23.
//

import XCTest
import Combine
import CoreLocation
@testable import MVVM_FoodFinder

@MainActor
class PlacesViewModelTests: XCTestCase {
    private var sut: PlacesViewModel!
    private var locationServiceMock: LocationServiceMock!
    private var searchRequestMock: SearchRequestMock!
    private var cancellables = Set<AnyCancellable>()
    private var placeMock = PlaceMock.makePlaces()
    
    override func setUp() {
        locationServiceMock = LocationServiceMock()
        searchRequestMock = SearchRequestMock()
        sut = PlacesViewModel(locationService: locationServiceMock, searchRequest: searchRequestMock)
    }
    
    func test_InitializerSetsViewStateToLoading() {
        XCTAssertTrue(sut.viewState == .loading)
    }
    
    func test_ShouldRefreshIsInitializedToFalse() {
        XCTAssertFalse(sut.shouldRefresh)
    }
    
    func test_PlacesIsInitializedEmpty() {
        XCTAssertTrue(sut.places.isEmpty)
    }
    
    func test_InitializerSetsIsAuthorizedToLocationServiceValue() {
        XCTAssertEqual(sut.isLocationAuthorized, locationServiceMock.isAuthorized.value)
    }
    
    func test_ViewIsEmpty_IsTrue_WhenPlacesIsEmpty() {
        searchRequestMock.places = []
        XCTAssertTrue(sut.viewIsEmpty)
    }
    
    func test_SetUp_WillSetupLocationService() {
        XCTAssertFalse(locationServiceMock.setupWasCalled)
        sut.setup()
        XCTAssertTrue(locationServiceMock.setupWasCalled)
    }
    
    func test_SetUp_WillRequestLocation() {
        XCTAssertFalse(locationServiceMock.requestLocationWasCalled)
        sut.setup()
        XCTAssertTrue(locationServiceMock.requestLocationWasCalled)
    }
    
    func test_Places_GetsSet_WhenLocationChanges() {
        let location = CLLocation(latitude: -34.5, longitude: 55.8)
        searchRequestMock.places = placeMock

        XCTAssertTrue(sut.places.count == 0)
        
        sut.$places
            .dropFirst()
            .sink { places in
                XCTAssertTrue(places.contains(where: { $0.id == PlaceMock.id }))
            }
            .store(in: &cancellables)
        
        locationServiceMock.location.send(location)
    }
    
    func test_ViewStateGetsSetToReadyWhenPlacesAreSet() {
        let location = CLLocation(latitude: -34.5, longitude: 55.8)
        searchRequestMock.places = placeMock
        sut.$places
            .dropFirst()
            .sink { [weak self] places in
                XCTAssertTrue(self?.sut.viewState == .ready)
            }
            .store(in: &cancellables)
        
        locationServiceMock.location.send(location)
    }
    
    func test_ShouldRefreshWillTriggerLocationRequest() {
        XCTAssertFalse(locationServiceMock.requestLocationWasCalled)
        sut.shouldRefresh = true
        XCTAssertTrue(locationServiceMock.requestLocationWasCalled)
    }
    
    func test_ErrorFetchingPlacesWillSetPlacesToEmpty() {
        let location = CLLocation(latitude: -34.5, longitude: 55.8)
        searchRequestMock.places = placeMock
        searchRequestMock.mockError = SearchErrorMock.couldNotFetchPlaces
        
        sut.$places
            .dropFirst()
            .sink { places in
                XCTAssertTrue(places.isEmpty)
            }
            .store(in: &cancellables)
        
        locationServiceMock.location.send(location)        
    }
    
    func test_ErrorFetchingPlacesWillThrowAnException() {
        let location = CLLocation(latitude: -34.5, longitude: 55.8)
        let expected = SearchErrorMock.couldNotFetchPlaces
        searchRequestMock.places = placeMock
        searchRequestMock.mockError = expected
        
        sut.$places
            .dropFirst()
            .sink { places in
                XCTAssertThrowsError(expected)
            }
            .store(in: &cancellables)
        
        locationServiceMock.location.send(location)
    }
    
    func test_LocationErrorSetsPlacesToEmpty() {
        searchRequestMock.places = placeMock
        
        sut.$places
            .dropFirst()
            .sink { places in
                XCTAssertTrue(places.isEmpty)
            }
            .store(in: &cancellables)
        
        locationServiceMock.location.send(completion: .failure(LocationErrorMock.failedToSendUpdate))
    }
}


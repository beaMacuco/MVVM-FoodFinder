//
//  GoogleMapsTests.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 30/08/23.
//

import XCTest
import CoreLocation
@testable import MVVM_FoodFinder

class GoogleMapsTests: XCTestCase {
    private var sut: GoogleMaps!
    private let location = CLLocation(latitude: 22.22, longitude: 33.33)

    override func setUp() {
        super.setUp()
        sut = GoogleMaps()
    }
    
    func test_GetMapURLAddsLatitudeToUrl() {
        let url = sut.getMapURL(at: location.coordinate.latitude, location.coordinate.longitude)
        XCTAssertTrue(url.contains("\(location.coordinate.latitude)"))
    }
    
    func test_GetMapURLAddsLongitudeToUrl() {
        let url = sut.getMapURL(at: location.coordinate.latitude, location.coordinate.longitude)
        XCTAssertTrue(url.contains("\(location.coordinate.longitude)"))
    }
}

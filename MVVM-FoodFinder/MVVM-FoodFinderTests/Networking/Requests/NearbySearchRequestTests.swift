//
//  NearbySearchRequestTests.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 28/08/23.
//

import XCTest
import CoreLocation
@testable import MVVM_FoodFinder

class NearbySearchRequestTests: XCTestCase {
    var sut: NearbySearchRequest!
    var googleApiRequestMock: GooglApiRequestMock!
    
    override func setUp() {
        super.setUp()
        googleApiRequestMock = GooglApiRequestMock()
        sut = NearbySearchRequest(googleApiRequest: googleApiRequestMock)
    }
    
    func test_FetchAddsLocationToEndpoint() async {
        let location = CLLocation(latitude: 34.0, longitude: 55.0)
        guard let _ = try? await sut.fetch(by: location),
              let url = googleApiRequestMock.urlString else {
            XCTFail("Should not have thrown error here")
            return
        }
        
        XCTAssertTrue(url.contains("\(location.coordinate.latitude)") && url.contains("\(location.coordinate.latitude)"))
    }
}

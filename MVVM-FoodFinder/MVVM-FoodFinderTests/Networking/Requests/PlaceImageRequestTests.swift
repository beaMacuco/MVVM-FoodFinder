//
//  PlaceImageRequestTests.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 28/08/23.
//

import XCTest
import CoreLocation
@testable import MVVM_FoodFinder

class PlaceImageRequestTests: XCTestCase {
    var sut: PlaceImageRequest!
    var googleApiRequestMock: GooglApiRequestMock!
    
    override func setUp() {
        super.setUp()
        googleApiRequestMock = GooglApiRequestMock()
        sut = PlaceImageRequest(googleRequest: googleApiRequestMock)
    }
    
    func test_FetchAddsLocationToEndpoint() async {
        let reference = "some id"
        guard let _ = try? await sut.fetch(by: reference),
              let url = googleApiRequestMock.urlString else {
            XCTFail("Should not have thrown error here")
            return
        }
        XCTAssertTrue(url.contains(reference))
    }
}

//
//  PlaceViewModelTests.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 31/08/23.
//

import XCTest
import SwiftUI
import Combine
@testable import MVVM_FoodFinder

@MainActor
class PlaceViewModelTests: XCTestCase {
    private var sut: PlaceViewModel!
    private var placeMock: Place!
    private var imageFetcher: ImageFetcherMock!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        placeMock = PlaceMock.makePlace()
        imageFetcher = ImageFetcherMock()
        sut = PlaceViewModel(place: placeMock, imageFetcher: imageFetcher)
    }
    
    func test_PlaceNameSetCorrectly() {
        XCTAssertEqual(sut.place.name, placeMock.name)
    }
    
    func test_PlaceAddressSetCorrectly() {
        XCTAssertEqual(sut.place.address, placeMock.address)
    }
    
    func test_URLHasCorrectLatitude() {
        guard let latitude = placeMock.location?.lat,
              let mapUrl = sut.mapURL else {
            XCTFail("Set latitude in mock")
            return
        }
        XCTAssertTrue(mapUrl.absoluteString.contains("\(latitude)"))
    }
    
    func test_URLHasCorrectLongitude() {
        guard let longitude = placeMock.location?.lng,
              let mapUrl = sut.mapURL else {
            XCTFail("Set longitude in mock")
            return
        }
        XCTAssertTrue(mapUrl.absoluteString.contains("\(longitude)"))
    }
    
    func test_RatingIsSetCorrectly() {
        guard let expected = placeMock.rating, let rating = sut.rating else {
            XCTFail("Set rating in mock")
            return
        }
        
        let starCount: Double = Double(rating.components(separatedBy: Symbols.Emoji.rating).count) - 1
        
        XCTAssertEqual(starCount, expected)
    }
    
    func test_PriceLevelIsSetCorrectly() {
        guard let expected = placeMock.priceLevel, let priceLevel = sut.priceLevel else {
            XCTFail("Set price level in mock")
            return
        }
        
        let priceLevelCount = priceLevel.components(separatedBy: Symbols.Emoji.priceLevel).count - 1
        
        XCTAssertEqual(priceLevelCount, expected)
    }
    
    func test_OpeningOursSetCorrectly() {
        guard let isOpen = sut.isOpen else {
            XCTFail("Set price level in mock")
            return
        }

        XCTAssertTrue(isOpen.contains(Symbols.Emoji.isOpen))
    }
    
    func test_FetchImageWillNotRequestImageIfThereIsNoImageReference() {
        sut.fetchImage()
        XCTAssertFalse(imageFetcher.isFetched)
    }
    
    func test_FetchImageWillSetImagePublisherValue() {
        placeMock = PlaceMock.makePlace([PlacePhoto(reference: "12345")])
        imageFetcher = ImageFetcherMock()
        sut = PlaceViewModel(place: placeMock, imageFetcher: imageFetcher)
        
        sut.$image
            .dropFirst()
            .sink { image in
            XCTAssertNotNil(image)
        }
        .store(in: &cancellables)
    
        sut.fetchImage()
    }
}

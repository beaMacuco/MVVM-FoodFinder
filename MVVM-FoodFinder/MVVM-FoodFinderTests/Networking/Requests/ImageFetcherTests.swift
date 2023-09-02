//
//  ImageFetcherTests.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 30/08/23.
//

import XCTest
@testable import MVVM_FoodFinder

class ImageFetcherTests: XCTestCase {
    var sut: ImageFetcher!
    var imageRequestMock: ImageRequestMock!
    var cache: ImageCacheMock!
    
    override func setUp() {
        super.setUp()
        imageRequestMock = ImageRequestMock()
        cache = ImageCacheMock()
        sut = ImageFetcher(cache: cache, imageRequest: imageRequestMock)
    }
    
    func test_WhenImageCacheExists_ThenImagesGetsRetrievedFromCache() async {
        let reference = "1231"
        cache.persist(image: UIImage(), by: reference)
        _ = try? await sut.fetchImage(from: reference)
        
        XCTAssertFalse(imageRequestMock.isRemoteImage)
    }
    
    func test_WhenImageCacheDoesNotExists_ThenImagesGetsRetrievedServer() async {
        let reference = "1231"
        _ = try? await sut.fetchImage(from: reference)
        
        XCTAssertTrue(imageRequestMock.isRemoteImage)
    }
    
    func test_WhenImageCannotBeDecoded_ThenCorruptedDataErrorIsThrown() async {
        let reference = "1231"
        imageRequestMock.throwsError = true
        
        do {
            _ = try await sut.fetchImage(from: reference)
            XCTFail("Should have thrown ImageError")
        } catch {
            guard let error: ImageError = error as? ImageError else {
                return XCTFail("Should have thrown ImageError")
            }
            XCTAssertEqual(error, .dataCorrupted)
        }
    }
    
    func test_ImageFetcherFetchesImage() async {
        let reference = "1231"
        let image = try? await sut.fetchImage(from: reference)
        
        XCTAssertNotNil(image)
    }
}

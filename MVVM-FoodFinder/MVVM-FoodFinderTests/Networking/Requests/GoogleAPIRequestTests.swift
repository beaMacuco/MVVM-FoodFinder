//
//  GoogleAPIRequestTests.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 25/08/23.
//

import XCTest
@testable import MVVM_FoodFinder

class GoogleAPIRequestTests: XCTestCase {
    var sut: GoogleRequestDecorator!
    var networkingMock: NetworkingMock!
    
    override func setUp() {
        super.setUp()
        networkingMock = NetworkingMock()
        sut = GoogleRequestDecorator(networking: networkingMock)
    }
    
    func test_ApiKeyGetsAppendedToUrl() async {
        let url = "test.com"
        do {
            _ = try await sut.request(from: url)
            guard let signedUrl = networkingMock.signedUrl else {
                XCTFail("Mock should assign value to signedUrl")
                return
            }
            XCTAssertTrue(signedUrl.contains("key"))
        } catch {
            XCTFail("Should complete request")
        }
    }
    
    func test_Given_DecodedResponse_WhenNoError_ThenDecodedObjectIsReturned() {
        let test = DecodableObject(id: 22, name: "test name")
        let apiResults = GoogleApiResults(results: test, status: "Ok", errorMessage: nil)
        
        guard let encoded = try? JSONEncoder().encode(apiResults) else {
            XCTFail("could not encode value")
            return
        }
        
        do {
            let decoded: DecodableObject = try sut.decode(from: encoded)
            XCTAssertEqual(test.id, decoded.id)
            
        } catch {
            XCTFail("should NOT throw error because it has no error message")
        }
    }
    
    func test_Given_DecodedResponse_WhenError_ThenErrorMessageIsThrown() {
        let expected = "your api key is invalid"
        let test = DecodableObject(id: 22, name: "test")
        let apiResults = GoogleApiResults(results: test, status: "Error", errorMessage: expected)
        
        guard let encoded = try? JSONEncoder().encode(apiResults) else {
            XCTFail("could not encode value")
            return
        }
        
        do {
            let decoded: DecodableObject = try sut.decode(from: encoded)
            XCTFail("\(decoded) should throw error because it has an error message")
            
        } catch {
            guard let networkingError: NetworkingError = error as? NetworkingError,
                  case .responseError = networkingError else {
                XCTFail("error is not decoding error")
                return
            }
            XCTAssert(true)
        }
    }
}

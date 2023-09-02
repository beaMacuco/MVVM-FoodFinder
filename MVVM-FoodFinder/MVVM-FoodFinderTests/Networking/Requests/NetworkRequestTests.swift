//
//  NetworkRequestTests.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 25/08/23.
//

import XCTest
@testable import MVVM_FoodFinder

class NetworkRequestTests: XCTestCase {
    private var sut: NetworkRequest!
    private let testUrl = "www.test.com"
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let urlSession = URLSession(configuration: configuration)
        sut = NetworkRequest(urlSession: urlSession)
    }
    
    func test_GivenANetworkRequest_WhenURLisMalformed_ThenMalformedErrorIsThrown() async {
        let malformed = ""
        
        do {
            _ = try await sut.request(from: malformed)
            XCTFail("Should have thrown malformed url error")
        } catch {
            XCTAssertEqual((error as? NetworkingError), NetworkingError.malformedUrl)
        }
    }
    
    func test_GivenANetworkRequest_WhenTheResponseIsInvalid_ThenInvalidResponseErrorIsThrown() async {
        guard let url = URL(string: testUrl) else {
            XCTFail("URL is nil")
            return
        }
        
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        
        URLProtocolMock.requestHandler = { request in
            (response, Data())
        }
        
        do {
            _ = try await sut.request(from: testUrl)
            XCTFail("Should have thrown invalid response error")
        } catch {
            XCTAssertEqual((error as? NetworkingError), NetworkingError.invalidResponse)
        }
    }
    
    func test_GivenANetworkRequest_WhenTheResponseContainsHttpErrors_ThenHttpResponseErrorIsThrown() async {
        let statusCode = 400
        guard let url = URL(string: testUrl), let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil) else {
            XCTFail("HTTPURLResponse or URL is nil")
            return
        }
        
        URLProtocolMock.requestHandler = { request in
            (response, Data())
        }
        
        do {
            _ = try await sut.request(from: testUrl)
            XCTFail("Should have thrown http response error")
        } catch {
            XCTAssertEqual((error as? NetworkingError), NetworkingError.httpResponseError(statusCode))
        }
    }
    
    func test_GivenANetworkRequest_WhenTheResponseContainsNoErrors_ThenDataIsReturned() async {
        guard let url = URL(string: testUrl), let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else {
            XCTFail("HTTPURLResponse or URL is nil")
            return
        }
        
        URLProtocolMock.requestHandler = { request in
            (response, Data())
        }
        
        do {
            let data = try await sut.request(from: testUrl)
            XCTAssertNotNil(data)
            
        } catch {
            XCTFail("Should have returned data as a response")
        }
    }
    
    func test_GivenDecode_WhenTheDataIsInCorrectFormat_ThenAnObjectIsReturned() {
        let object = DecodableObject(id: 22, name: "test name")
        guard let data: Data = try? JSONEncoder().encode(object) else {
            XCTFail("Could not encode data")
            return
        }
        
        do {
            let decoded: DecodableObject = try sut.decode(from: data)
            XCTAssertEqual(object.id, decoded.id)
        } catch {
            XCTFail("Should have decoded data")
        }
    }
    
    func test_GivenDecode_WhenTheDataIsNotInCorrectFormat_ThenDecodingErrorIsThrown() {
        guard let data = "some string".data(using: .utf8) else {
            XCTFail("Could not encode data")
            return
        }
        
        do {
            let decoded: DecodableObject = try sut.decode(from: data)
            XCTFail("\(decoded) should not have failed decoding")
        } catch {
            guard let networkingError: NetworkingError = error as? NetworkingError,
                  case .decodingError = networkingError else {
                XCTFail("error is not decoding error")
                return
            }
            XCTAssert(true)
        }
    }
}



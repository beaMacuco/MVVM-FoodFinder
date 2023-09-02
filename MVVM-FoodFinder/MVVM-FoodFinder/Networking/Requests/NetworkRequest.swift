//
//  NetworkRequest.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 29/07/23.
//

import Foundation

protocol Networking {
    func request(from urlString: String) async throws ->  Data
    func decode<T: Codable>(from data: Data) throws -> T
}

struct NetworkRequest: Networking {
    private let successStatusCodeRange = 200..<300
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func request(from urlString: String) async throws ->  Data {
        guard let url = URL(string: urlString) else {
            throw NetworkingError.malformedUrl
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.invalidResponse
        }
        
        guard successStatusCodeRange.contains(httpResponse.statusCode) else {
            throw NetworkingError.httpResponseError(httpResponse.statusCode)
        }
        
        return data
    }
    
    func decode<T: Codable>(from data: Data) throws -> T {
        let decoder = JSONDecoder()
        var decodeResponse: T

        do {
            decodeResponse = try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkingError.decodingError("\(error)")
        }
        
        return decodeResponse
    }
}

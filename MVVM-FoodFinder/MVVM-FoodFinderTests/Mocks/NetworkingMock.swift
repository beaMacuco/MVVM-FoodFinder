//
//  NetworkingMock.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 28/08/23.
//

import Foundation

class NetworkingMock: Networking {
    var signedUrl: String?
    
    func request(from urlString: String) async throws -> Data {
        signedUrl = urlString
        return urlString.data(using: .utf8) ?? Data()
    }
    
    func decode<T: Codable>(from data: Data) throws -> T {
        let decoded: T = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
}

//
//  GooglApiRequestMock.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 28/08/23.
//

import Foundation

class GooglApiRequestMock: Networking {
    var urlString: String?
    
    func request(from urlString: String) async throws -> Data {
        self.urlString = urlString
        return urlString.data(using: .utf8) ?? Data()
    }
    
    func decode<T: Codable>(from data: Data) throws -> T {
        let result: T = [Place(photos: nil, geometry: nil, id: "22", businessStatus: nil, name: nil, openingHours: nil, priceLevel: nil, rating: nil, address: nil)] as! T
        return result
    }
}

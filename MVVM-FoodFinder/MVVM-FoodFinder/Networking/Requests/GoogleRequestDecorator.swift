//
//  GoogleAPIRequest.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 22/08/23.
//

import Foundation

struct GoogleRequestDecorator: Networking {
    private let networking: Networking
    private static let API_KEY = "AIzaSyDaHRZmGb5AUxyYrjMsxSM4834VsVoq_30"
    
    init(networking: Networking = NetworkRequest()) {
        self.networking = networking
    }
    
    func request(from urlString: String) async throws -> Data {
        let signedString = appendAPIKey(to: urlString)
        let data: Data = try await networking.request(from: signedString)
        return data
    }
    
    private func appendAPIKey(to urlString: String) -> String {
        "\(urlString)&key=\(Self.API_KEY)"
    }
    
    func decode<T: Codable>(from data: Data) throws -> T {
        let decoded: GoogleApiResults<T> = try networking.decode(from: data)
        return try processResponse(response: decoded)
    }
    
    private func processResponse<T: Codable>(response: GoogleApiResults<T>) throws -> T {
        if let errorMessage = response.errorMessage {
            throw NetworkingError.responseError(errorMessage)
        }
        return response.results
    }
}

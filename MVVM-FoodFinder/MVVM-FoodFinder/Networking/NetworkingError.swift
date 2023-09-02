//
//  NetworkingError.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 19/07/23.
//

import Foundation

enum NetworkingError: Error, Equatable {
    case malformedUrl
    case invalidResponse
    case httpResponseError(Int)
    case decodingError(String)
    case responseError(String)
}

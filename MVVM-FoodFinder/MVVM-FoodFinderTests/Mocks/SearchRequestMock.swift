//
//  SearchRequestMock.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 29/08/23.
//

import Foundation
import CoreLocation

enum SearchErrorMock: Error {
    case couldNotFetchPlaces
}

class SearchRequestMock: SearchRequest {
    var places: [Place] = []
    var mockError: SearchErrorMock?
    
    func fetch(by location: CLLocation) async throws -> [Place] {
        guard mockError == nil else {
            throw SearchErrorMock.couldNotFetchPlaces
        }
        return places
    }
}

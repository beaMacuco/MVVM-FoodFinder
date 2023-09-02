//
//  PlacesViewModel.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 29/07/23.
//

import Foundation
import CoreLocation
import Combine
import os

@MainActor
final class PlacesViewModel: ObservableObject {
    private let logger = Logger.make(for: PlaceViewModel.self)
    private let locationService: LocationService
    private let searchRequest: SearchRequest
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var places: [Place] = []
    @Published private(set) var isLocationAuthorized: Bool
    @Published var shouldRefresh: Bool = false
    @Published var viewState: ViewState
    
    var viewIsEmpty: Bool {
        places.isEmpty
    }
    
    init(locationService: LocationService = UserLocationService(), searchRequest: SearchRequest = NearbySearchRequest()) {
        self.locationService = locationService
        self.searchRequest = searchRequest
        self.isLocationAuthorized = locationService.isAuthorized.value
        self.viewState = .loading
        
        locationService.isAuthorized
            .weakAssign(to: \.isLocationAuthorized, on: self)
            .store(in: &cancellables)
        
        locationService.location
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.handle(error: error)
                }
            }, receiveValue: { [weak self] location in
                self?.requestPlaces(location: location)
            })
            .store(in: &cancellables)
        
        $shouldRefresh
            .filter { $0 == true }
            .sink { [weak self] shouldRefresh in
                self?.locationService.requestLocation()
            }
            .store(in: &cancellables)
    }
    
    func setup() {
        locationService.setUp()
        locationService.requestLocation()
    }
    
    private func requestPlaces(location: CLLocation) {
        Task {
            do {
                places = try await searchRequest.fetch(by: location)
            } catch {
                handle(error: error)
            }
            viewState = .ready
        }
    }
    
    private func handle(error: Error) {
        // TODO: Add toast to explain places could not be fetched
        logger.error("\(error)")
        places = []
    }
}

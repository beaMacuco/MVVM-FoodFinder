//
//  ImageFetcher.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 22/08/23.
//

import UIKit
import SwiftUI

enum ImageError: Error {
    case dataCorrupted
}

protocol ImageFetchable {
    func fetchImage(from reference: String) async throws -> Image
}

class ImageFetcher: ImageFetchable {
    private let cache: ImageCachable
    private let imageRequest: ImageRequest
    
    init(cache: ImageCachable = ImageCache(), imageRequest: ImageRequest = PlaceImageRequest()) {
        self.cache = cache
        self.imageRequest = imageRequest
    }
    
    func fetchImage(from reference: String) async throws -> Image {
        guard let uiImage = cache.fetch(by: reference) else {
            return try await fetchRemoteImage(from: reference)
        }
        return Image(uiImage: uiImage)
    }
    
    private func fetchRemoteImage(from reference: String) async throws -> Image {
        let data = try await imageRequest.fetch(by: reference)
        guard let requestedImage = UIImage(data: data) else {
            throw ImageError.dataCorrupted
        }
        cache.persist(image: requestedImage, by: reference)
        return Image(uiImage: requestedImage)
    }
}

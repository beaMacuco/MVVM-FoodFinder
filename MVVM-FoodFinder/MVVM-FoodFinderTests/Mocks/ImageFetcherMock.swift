//
//  ImageFetcherMock.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 31/08/23.
//

import SwiftUI

class ImageFetcherMock: ImageFetchable {
    var isFetched = false
    
    func fetchImage(from reference: String) async throws -> Image {
        isFetched = true
        return Image(systemName: Symbols.imagePlaceholder)
    }
}

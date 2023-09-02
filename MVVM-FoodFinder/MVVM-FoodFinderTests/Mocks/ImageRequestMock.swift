//
//  ImageRequestMock.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 30/08/23.
//

import UIKit

class ImageRequestMock: ImageRequest {
    var isRemoteImage = false
    var throwsError = false
    
    func fetch(by reference: String) async throws -> Data {
        isRemoteImage = true
        var image: UIImage?
        if throwsError {
            guard let data = reference.data(using: .utf8) else {
                return Data()
            }
            image = UIImage(data: data)
        } else {
            image = UIImage(systemName: Symbols.imagePlaceholder)
        }
        return image?.pngData() ?? Data()
    }
}

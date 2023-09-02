//
//  ImageCacheMock.swift
//  MVVM-FoodFinderTests
//
//  Created by Beatriz Loures Macuco on 30/08/23.
//

import UIKit

class ImageCacheMock: ImageCachable {
    var persistedItems: [String: UIImage] = [:]
    
    func fetch(by reference: String) -> UIImage? {
        persistedItems[reference]
    }
    
    func persist(image: UIImage, by reference: String) {
        persistedItems[reference] = image
    }
}

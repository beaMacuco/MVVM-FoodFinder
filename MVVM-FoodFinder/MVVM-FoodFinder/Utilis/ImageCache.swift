//
//  ImageCache.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 30/08/23.
//

import UIKit

protocol ImageCachable {
    func fetch(by reference: String) -> UIImage?
    func persist(image: UIImage, by reference: String)
}

class ImageCache: ImageCachable {
    private let cache: NSCache<NSString, UIImage>
    
    init(cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()) {
        self.cache = cache
    }
    
    func fetch(by reference: String) -> UIImage? {
        cache.object(forKey: (reference as NSString))
    }
    
    func persist(image: UIImage, by reference: String) {
        cache.setObject(image, forKey: (reference as NSString))
    }
}

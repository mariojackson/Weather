//
//  ImageCache.swift
//  Weather
//
//  Created by Mario Jackson on 3/27/23.
//

import UIKit

/// Image cache provides functionality to cache images
struct ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    /// Returns a UIImage if it's cached by the given URL.
    ///   - Parameters:
    ///     - forUrl: The image URL
    func get(forUrl url: String) -> UIImage? {
        return cache.object(forKey: NSString(string: url))
    }
    
    /// Puts the given image into the image cache. The given URL will be used as its  key.
    ///   - Parameters:
    ///       - image: Image to cache
    ///       - forUrl: Image url
    func set(_ image: UIImage, forUrl url: String) {
        cache.setObject(image, forKey: NSString(string: url))
    }
    
    /// Removes all images from the image cache.
    func removeAll() {
        cache.removeAllObjects()
    }
}

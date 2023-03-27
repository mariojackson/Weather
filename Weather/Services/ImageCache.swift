//
//  ImageCache.swift
//  Weather
//
//  Created by Mario Jackson on 3/27/23.
//

import UIKit

struct ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
}

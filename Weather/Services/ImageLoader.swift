//
//  ImageLoader.swift
//  Weather
//
//  Created by Mario Jackson on 3/30/23.
//

import UIKit


struct ImageLoader {
    static let shared = ImageLoader()
    let cache = ImageCache.shared
    
    private init() {}
    
    /// Loads an image by the given URL
    /// - Parameters:
    ///   - url: Image URL
    ///   - completion: callback with either an UIImage or an error
    func loadBy(url: String, completion: @escaping(Result<UIImage, Error>) -> Void) {
        if let image = cache.get(forUrl: url) {
            return completion(.success(image))
        }
        
        guard let url = URL(string: url) else {
            print("Error creating URL from: \(url)")
            return
        }
        
        NetworkService.shared.fetchImage(url: url) { result in
            switch result {
            case .success(let image):
                cache.set(image, forUrl: url.absoluteString)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Loads images by the given array of links
    /// - Parameters:
    ///   - links: Array of URL's
    ///   - completion: callback with either an UIImage or an error
    func loadBy(links imageLinks: [String], completion: @escaping(Result<[String:UIImage], Error>) -> Void) {
        let uncachedImageLinks = imageLinks.filter { ImageCache.shared.get(forUrl: $0) == nil }
        let dispatchGroup = DispatchGroup()
        
        uncachedImageLinks.forEach { link in
            dispatchGroup.enter()
            
            guard let url = URL(string: link) else {
                dispatchGroup.leave()
                return
            }
            
            NetworkService.shared.fetchImage(url: url) { result in
                defer {
                    dispatchGroup.leave()
                }
                
                switch result {
                case .success(let image):
                    cache.set(image, forUrl: link)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            let images: [String:UIImage] = imageLinks.reduce(into: [String:UIImage]()) {
                $0[$1] = cache.get(forUrl: $1)
            }
            
            completion(.success(images))
        }
    }
}

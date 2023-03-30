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
    
    func loadBy(url: String, completion: @escaping(Result<ImageCache, Error>) -> Void) {
        guard let url = URL(string: url) else {
            print("Error creating URL from: \(url)")
            return
        }
        
        NetworkService.shared.fetchImage(url: url) { result in
            switch result {
            case .success(let image):
                cache.set(image, forUrl: url.absoluteString)
                completion(.success(cache))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadBy(links imageLinks: [String], completion: @escaping(Result<ImageCache, Error>) -> Void) {
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
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(ImageCache.shared))
        }
    }
}

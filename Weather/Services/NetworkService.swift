//
//  NetworkService.swift
//  Weather
//
//  Created by Mario Jackson on 3/13/23.
//

import UIKit


struct NetworkService {
    static let shared = NetworkService()
    
    private let weatherAPI = "https://api.weatherapi.com/v1/forecast.json?key=8caa2054d433489e862170320231103" // TODO: Get API key from environment
    
    private init() {}
    
    enum NetworkServiceError: Error {
        case invalidUrl
        case failedToCreateRequest
        case failedToGetData

        case failedToGetImage
        case failedToCreateImage
    }
    
    /// Fetch image from the given URL and return a UIImage
    ///   - Parameters:
    ///      - url: URL to fetch the image from
    ///      - completion: Callback with either a UIImage or an error
    func fetchImage(url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                completion(.failure(NetworkServiceError.failedToGetImage))
                return
            }
            
            if let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(NetworkServiceError.failedToCreateImage))
            }
        }
    }
    
    /// Fetches the current weather from the given city.
    ///  - Parameters:
    ///     - from: City that the current weather should be fetched from
    ///     - completion: Callback with either data or an error
    func fetchWeather(from city: String, completion: @escaping(Result<Weather, Error>) -> Void) {
        let endpoint = "\(weatherAPI)&q=\(city)&aqi=no&days=5"
        
        fetch(url: endpoint, into: Weather.self) { result in
            switch result {
            case .success(let weather):
                completion(.success(weather))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetches and decodes the data from the given URL
    /// - Parameters:
    ///     - url: URL to fetch
    ///     - into: The type of the object expected to be decoded into - eg. CurrentWeather
    ///     - completion: Callback with either data or an error
    private func fetch<T: Decodable>(
        url: String,
        into type: T.Type,
        completion: @escaping(Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: url) else {
            completion(.failure(NetworkServiceError.invalidUrl))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(error ?? NetworkServiceError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}



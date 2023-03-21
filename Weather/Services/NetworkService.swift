//
//  NetworkService.swift
//  Weather
//
//  Created by Mario Jackson on 3/13/23.
//

import Foundation


struct NetworkService {
    static let shared = NetworkService()
    
    private let weatherAPI = "https://api.weatherapi.com/v1/current.json?key=8caa2054d433489e862170320231103" // TODO: Get API key from environment
    
    private init() {}
    
    enum NetworkServiceError: Error {
        case invalidUrl
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Fetches the current weather from the given city.
    ///  - Parameters:
    ///     - from: City that the current weather should be fetched from
    ///     - completion: Callback with either data or an error
    func fetchCurrentWeather(from city: String, completion: @escaping(Result<CurrentWeather, Error>) -> Void) {
        let endpoint = "\(weatherAPI)&q=\(city)&aqi=no"
        
        fetch(url: endpoint, into: CurrentWeather.self) { result in
            switch result {
            case .success(let currentWeather):
                completion(.success(currentWeather))
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



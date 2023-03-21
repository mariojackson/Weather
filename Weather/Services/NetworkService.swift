//
//  NetworkService.swift
//  Weather
//
//  Created by Mario Jackson on 3/13/23.
//

import Foundation


struct NetworkService {
    private let weatherAPI = "https://api.weatherapi.com/v1/current.json?key=8caa2054d433489e862170320231103" // TODO: Get API key from environment
    
    /// Fetches the current weather from the given city.
    func fetchCurrentWeather(from city: String, completion: @escaping((CurrentWeather?)) -> Void) {
        let endpoint = "\(weatherAPI)&q=\(city)&aqi=no"
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                print("Error while fetching data from API")
                return
            }
            
            do {
                let currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                completion(currentWeather)
            } catch {
                print("Error while decoding data: \(error.localizedDescription)")
            }
        }
        
        dataTask.resume()
    }
}



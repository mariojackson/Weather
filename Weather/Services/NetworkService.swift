//
//  NetworkService.swift
//  Weather
//
//  Created by Mario Jackson on 3/13/23.
//

import Foundation

let weatherAPI = "https://api.weatherapi.com/v1/current.json?key=ADD_YOUR_KEY" // TODO: Get API key from environment

func fetchCurrentWeather(from city: String, completion: @escaping((CurrentWeather?)) -> ()) {
    
    let currentWeatherURL = "\(weatherAPI)&q=\(city)&aqi=no"
    
    guard let url = URL(string: currentWeatherURL) else {
        print("Invalid URL")
        return
    }
    
    let request = URLRequest(url: url)
    
    let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
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

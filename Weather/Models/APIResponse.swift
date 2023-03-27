//
//  APIResponse.swift
//  Weather
//
//  Created by Mario Jackson on 3/12/23.
//

import UIKit


struct Weather: Decodable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Location: Decodable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime_epoch: Int
    let localtime: String
}

struct Current: Decodable {
    let temp_c: Double
    let temp_f: Double
    let condition: Condition
    let feelslike_c: Double
    let feelslike_f: Double
}

struct Condition: Decodable {
    let text: String
    let icon: String
    let code: Int
}

struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let date: String
    let day: Day
}

struct Day: Decodable {
    let maxtemp_c: Double
    let maxtemp_f: Double
    let mintemp_c: Double
    let mintemp_f: Double
    let avgtemp_c: Double
    let avgtemp_f: Double
    let condition: Condition
}


extension Weather {
    var city: String {
        self.location.name
    }
    
    var temperatureC: String {
        "\(Int(self.current.temp_c.rounded())) °C"
    }
    
    var imageURL: String {
        "https:\(self.current.condition.icon)"
    }
    
    func getForecast(atIndex index: Int) -> ForecastDay? {
        guard isForecastIndexValid(index) else {
            assertionFailure("Invalid index at ApiResponse.getForecast")
            return nil
        }
        
        return self.forecast.forecastday[index]
    }
    
    func getDay(atIndex index: Int) -> String? {
        guard isForecastIndexValid(index) else {
            assertionFailure("Invalid index at ApiResponse.getDay")
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = self.forecast.forecastday[index].date
        let date = dateFormatter.date(from: dateString)
        
        guard let date else {
            return nil
        }
        
        let weekday = dateFormatter.weekdaySymbols[
            Calendar.current.component(.weekday, from: date) - 1
        ]

        return String(weekday)
    }
    
    private func isForecastIndexValid(_ index: Int) -> Bool {
        guard (self.forecast.forecastday.count - 1) >= index else {
            return false
        }
        
        return true
    }
}


extension ForecastDay {
    var maxDegreeC: String {
        "\(Int(self.day.maxtemp_c.rounded())) °C"
    }
    
    var minDegreeC: String {
        "\(Int(self.day.mintemp_c.rounded())) °C"
    }
}

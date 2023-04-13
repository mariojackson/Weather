//
//  Weather+Extensions.swift
//  Weather
//
//  Created by Mario Jackson on 3/28/23.
//

import Foundation


/// Extension for the Weather model
extension Weather {
    /// City name
    var city: String {
        self.location.name
    }
    
    /// Rounded temperature in Celsius
    var temperatureC: String {
        "\(Int(self.current.temperatureC.rounded())) °C"
    }
    
    /// Url to the image of the current weather
    var imageURL: String {
        "https:\(self.current.condition.icon)"
    }
    
    /// Returns the forecast day at the given index
    /// - Parameters:
    ///   - atIndex: The index of the wanted forecast
    /// - Returns: The forecast day if it exists
    func getForecast(atIndex index: Int) -> ForecastDay? {
        guard isForecastIndexValid(index) else {
            assertionFailure("Invalid index at ApiResponse.getForecast")
            return nil
        }
        
        return self.forecast.forecastday[index]
    }
    
    /// Returns the name of the week at the given index
    /// - Parameters:
    ///   - atIndex: The index of the wanted week day
    /// - Returns: The name of the week at the given index, if it exists
    func getWeekDay(atIndex index: Int) -> String? {
        guard isForecastIndexValid(index) else {
            assertionFailure("Invalid index at ApiResponse.getWeekDay")
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
    
    /// Checks if the given index exists in the forecasts.
    /// - Parameters:
    ///   - _: Index to check
    /// - Returns: True, if the given index is valid. Otherwise false.
    private func isForecastIndexValid(_ index: Int) -> Bool {
        guard (self.forecast.forecastday.count - 1) >= index else {
            return false
        }
        
        return true
    }
}


/// Extension for the ForecastDay model
extension ForecastDay {
    /// Maximum temperature of the day in Celsius
    var maxDegreeC: String {
        "\(Int(self.day.maxTempC.rounded())) °C"
    }
    
    /// Mininum temperature of the day in Celsius
    var minDegreeC: String {
        "\(Int(self.day.minTempC.rounded())) °C"
    }
    
    /// Icon URL of the image representing the weather of the day
    var iconUrl: String {
        "https:\(self.day.condition.icon)"
    }
    
    /// Weekday of the forecast
    var weekday: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = self.date
        let date = dateFormatter.date(from: dateString)
        
        guard let date else {
            return "Invalid date"
        }
        
        let weekday = dateFormatter.weekdaySymbols[
            Calendar.current.component(.weekday, from: date) - 1
        ]

        return String(weekday)
    }
}

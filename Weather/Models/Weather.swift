//
//  Weather.swift
//  Weather
//
//  Created by Mario Jackson on 3/12/23.
//

import UIKit

/// The defined models represent the response from the openweather.com API.
/// However, not all properties are declared in the models. Checkout the
/// openweather.com documentation if you need more properties.

/// Weather representation, that comes as the response from the API
struct Weather: Decodable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

/// Location representation, that comes as the response from the API
/// and is used inside the weather struct.
struct Location: Decodable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let timezoneId: String
    let localtimeEpoch: Int
    let localtime: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case region = "region"
        case country = "country"
        case lat = "lat"
        case lon = "lon"
        case timezoneId = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime = "localtime"
    }
}

/// Current representation, that comes as the response from the API
/// and is used inside the weather struct.
struct Current: Decodable {
    let temperatureC: Double
    let temperatureF: Double
    let condition: Condition
    let feelslikeC: Double
    let feelslikeF: Double
    
    private enum CodingKeys: String, CodingKey {
        case temperatureC = "temp_c"
        case temperatureF = "temp_f"
        case condition = "condition"
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
    }
}

/// Forcast representation, that comes as the response from the api
/// and is used inside the weather struct.
struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}

/// Condition representation, that comes as the response from the api
/// and is used inside the weather struct.
struct Condition: Decodable {
    let text: String
    let icon: String
    let code: Int
}

/// Condition representation, that comes as the response from the api
/// and is used inside the weather struct.
struct ForecastDay: Decodable {
    let date: String
    let day: Day
}

/// Day representation, that comes as the response from the api
/// and is used inside the ForecastDay struct.
struct Day: Decodable {
    let maxTempC: Double
    let maxTempF: Double
    let minTempC: Double
    let minTempF: Double
    let avgTempC: Double
    let avgTempF: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case maxTempC = "maxtemp_c"
        case maxTempF = "maxtemp_f"
        case minTempC = "mintemp_c"
        case minTempF = "mintemp_f"
        case avgTempC = "avgtemp_c"
        case avgTempF = "avgtemp_f"
        case condition = "condition"
    }
}

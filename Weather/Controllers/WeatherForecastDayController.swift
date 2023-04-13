//
//  WeatherForecastDayController.swift
//  Weather
//
//  Created by Mario Jackson on 4/13/23.
//

import UIKit


class WeatherForecastDayController: UIViewController {
    public var forecastDay: ForecastDay
    
    override func viewDidLoad() {
        view.backgroundColor = .orange
    }
    
    init(forecastDay: ForecastDay) {
        self.forecastDay = forecastDay
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

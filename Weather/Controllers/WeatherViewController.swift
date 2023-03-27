//
//  WeatherViewController.swift
//  Weather
//
//  Created by Mario Jackson on 3/11/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let tableView = UITableView()
    let weatherView = WeatherView()
    
    var weather: Weather?
    var city: String?
    var safeArea: UILayoutGuide!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        safeArea = view.layoutMarginsGuide
        setupTableView()
    }
    
    override func loadView() {
        super.loadView()
        
        guard let city else {
            assertionFailure("City not set")
            return
        }
        
        fetchWeather(from: city)
    }
    
    private func setupTableView() {
        view.addSubview(weatherView)
        view.addSubview(tableView)
        
        tableView.register(
            WeatherTableViewCell.self,
            forCellReuseIdentifier: WeatherTableViewCell.identifier
        )
        
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 40
        
        style()
        layout()
    }
}


extension WeatherViewController {
    private func style() {
        title = "Weather"
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            weatherView.heightAnchor.constraint(equalToConstant: 200),
            weatherView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: weatherView.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}


// MARK: - Data Source
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather?.forecast.forecastday.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WeatherTableViewCell.identifier,
            for: indexPath) as? WeatherTableViewCell else {
            fatalError("TableView could not dequeue resuable cell in WeatherViewController")
        }
        
        guard let forecast = self.weather?.getForecast(atIndex: indexPath.row) else {
            return cell
        }
        
        cell.configure(
            withImage: ImageCache.shared.getImage(forUrl: forecast.iconUrl),
            day: self.weather?.getDay(atIndex: indexPath.row) ?? "Invalid Day",
            maxDegree: forecast.maxDegreeC,
            minDegree: forecast.minDegreeC
        )
        
        return cell
    }
}


// MARK: - Helper Methods
extension WeatherViewController {
    
    private func fetchWeather(from city: String) {
        NetworkService.shared.fetchWeather(from: city) { result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self.weather = weather
                    self.fetchForecastImages()
                }
            case .failure(let error):
                print("Error fetching weather: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchForecastImages() { // TODO: Ask BJ if there is a better way to do it.
        guard let forecasts = weather?.forecast.forecastday else {
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        forecasts.forEach { forecast in
            dispatchGroup.enter()
            
            if ImageCache.shared.getImage(forUrl: forecast.iconUrl) != nil {
                print("Using cached image for: \(forecast.iconUrl)")
                return
            }
            
            guard let url = URL(string: forecast.iconUrl) else {
                dispatchGroup.leave()
                return
            }
            
            NetworkService.shared.fetchImage(url: url) { result in
                dispatchGroup.leave()
                
                switch result {
                case .success(let image):
                    ImageCache.shared.setImage(image, forUrl: forecast.iconUrl)
                case .failure(let error):
                    print("Error fetching forecast image: \(error.localizedDescription)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.updateUI()
        }
    }
    
    private func setHeaderImage(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        NetworkService.shared.fetchImage(url: url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.weatherView.imageView.image = image
                }
            case .failure(let error):
                print("Error fetching image: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateUI() {
        guard let weather = self.weather else {
            print("Weather cannot be nil")
            return
        }
        
        self.weatherView.cityLabel.text = weather.city
        self.weatherView.degreesLabel.text = weather.temperatureC
        self.setHeaderImage(url: weather.imageURL)
        
        self.tableView.reloadData() // TODO: Is that a bad way to do it, so that the table view data source gets called?
    }
}

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
        tableView.rowHeight = 50
        
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
            
            tableView.topAnchor.constraint(equalTo: weatherView.bottomAnchor),
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
    
       cell.configure(
            withImage: UIImage(systemName: "cloud"), // TODO: set forecast image
            label: weather?.getDay(atIndex: indexPath.row) ?? "Invalid Day"
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
                    self.update(weather: weather)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    private func setImage(url: String) {
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
                print(String(describing: error))
            }
        }
    }
    
    private func update(weather: Weather) {
        self.weather = weather // Needs to be set its used to set the number of rows
        
        self.weatherView.cityLabel.text = weather.city
        self.weatherView.degreesLabel.text = weather.temperatureC
        self.setImage(url: weather.imageURL)
        
        self.tableView.reloadData() // TODO: Is that a bad way to do it, so that the table view data source gets called?
    }
}

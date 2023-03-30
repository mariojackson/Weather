//
//  WeatherViewController.swift
//  Weather
//
//  Created by Mario Jackson on 3/11/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    private let tableView = UITableView()
    private let weatherView = WeatherView()
    private var weather: Weather?
    private var safeArea: UILayoutGuide!
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    var city: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        safeArea = view.layoutMarginsGuide
        configureTableView()
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    override func loadView() {
        super.loadView()
        
        fetchWeather(from: city)
    }
    
    init(city: String) {
        self.city = city
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - View Configuration
extension WeatherViewController {
    private func configureView() {
        title = "Weather"
        
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
    
    private func configureTableView() {
        view.addSubview(weatherView)
        view.addSubview(tableView)
        
        tableView.register(
            WeatherTableViewCell.self,
            forCellReuseIdentifier: WeatherTableViewCell.identifier
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 40
        
        configureView()
    }
}


// MARK: - Data Source
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
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
            withImage: ImageCache.shared.get(forUrl: forecast.iconUrl),
            day: self.weather?.getWeekDay(atIndex: indexPath.row) ?? "Invalid Day",
            maxDegree: forecast.maxDegreeC,
            minDegree: forecast.minDegreeC
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        print(cell)
    }
}


// MARK: - Helper Methods
extension WeatherViewController {
    
    private func fetchWeather(from city: String) {
        activityIndicator.startAnimating()
        
        NetworkService.shared.fetchWeather(from: city) { result in
            defer {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()                }
            }
            
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
    
    private func fetchForecastImages() {
        guard let forecasts = weather?.forecast.forecastday else {
            return
        }
        
        let imageLinks = forecasts.map { $0.iconUrl }
        ImageLoader.shared.loadBy(links: imageLinks) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.updateUI()
                }
            case .failure(let error):
                print("Error fetching image: \(error.localizedDescription)")
            }
        }
    }
    
    private func setHeaderImage(url: String) {
        ImageLoader.shared.loadBy(url: url) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.weatherView.imageView.image = ImageCache.shared.get(forUrl: url)
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

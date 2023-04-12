//
//  WeatherTableViewController.swift
//  Weather
//
//  Created by Mario Jackson on 4/12/23.
//

import UIKit


protocol WeatherTableViewControllerDelegate {
    func didFetchForecastImages()
}

class WeatherTableViewController: UIViewController {
    private var weather: Weather
    private var forecastImages: [String:UIImage]?
    
    public let tableView = UITableView()
    
    var delegate: WeatherTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureStyle()
        configureView()
    }
    
    init(weather: Weather) {
        self.weather = weather
        
        super.init(nibName: nil, bundle: nil)
        
        self.fetchForecastImages()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - View Configuration
extension WeatherTableViewController {
    func configureStyle() {
        view.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.rowHeight = 40
    }
    
    func configureView() {
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 1),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 1)
        ])
        

    }
}


// MARK: - Delegates and Data Source
extension WeatherTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.forecast.forecastday.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WeatherTableViewCell.identifier,
            for: indexPath) as? WeatherTableViewCell else {
            fatalError("TableView could not dequeue resuable cell in WeatherViewController")
        }
        
        guard let forecast = weather.getForecast(atIndex: indexPath.row) else {
            return cell
        }
        
        guard let forecastImages else {
            return cell
        }
        
        cell.configure(
            withImage: forecastImages[forecast.iconUrl],
            day: weather.getWeekDay(atIndex: indexPath.row) ?? "Invalid Day",
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
extension WeatherTableViewController {
    private func fetchForecastImages() {
        let forecasts = weather.forecast.forecastday
        
        let imageLinks = forecasts.map { $0.iconUrl }
        ImageLoader.shared.loadBy(links: imageLinks) { result in
            switch result {
            case .success(let images):
                self.forecastImages = images
                self.delegate?.didFetchForecastImages()
            case .failure(let error):
                print("Error fetching image: \(error.localizedDescription)")
            }
        }
    }
}

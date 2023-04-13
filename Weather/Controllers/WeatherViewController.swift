//
//  WeatherViewController.swift
//  Weather
//
//  Created by Mario Jackson on 3/11/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    private var weatherTableVC: WeatherTableViewController!
    private let weatherView = WeatherView()
    private var weather: Weather?
    private var safeArea: UILayoutGuide!
    private var forecastImages = [String:UIImage]()
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    var city: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        safeArea = view.layoutMarginsGuide
        
        configureView()
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
        view.addSubview(weatherView)
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        title = "Weather"
        
        NSLayoutConstraint.activate([
            weatherView.heightAnchor.constraint(equalToConstant: 200),
            weatherView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func addTableView(weather: Weather) {
        weatherTableVC = WeatherTableViewController(weather: weather)
        weatherTableVC.delegate = self
        
        addChild(weatherTableVC)
        view.addSubview(weatherTableVC.view)
        
        NSLayoutConstraint.activate([
            weatherTableVC.view.topAnchor.constraint(equalToSystemSpacingBelow: weatherView.bottomAnchor, multiplier: 1),
            weatherTableVC.view.leadingAnchor.constraint(equalToSystemSpacingAfter: weatherView.leadingAnchor, multiplier: 1),
            weatherView.trailingAnchor.constraint(equalToSystemSpacingAfter: weatherTableVC.view.trailingAnchor, multiplier: 1),
            weatherTableVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        weatherTableVC.didMove(toParent: self)
    }
}


// MARK: - Helper Methods
extension WeatherViewController {
    
    private func fetchWeather(from city: String) {
        activityIndicator.startAnimating()
        
        NetworkService.shared.fetchWeather(from: city) { result in
            defer {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
            
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self.weather = weather
                    
                    self.addTableView(weather: weather)
                    self.weatherTableVC.view.alpha = 0
                }
            case .failure(let error):
                print("Error fetching weather: \(error.localizedDescription)")
            }
        }
    }
    
    private func setHeaderImage(url: String) {
        ImageLoader.shared.loadBy(url: url) { result in
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
        guard let weather else {
            print("Weather cannot be nil")
            return
        }
        
        weatherView.cityLabel.text = weather.city
        weatherView.degreesLabel.text = weather.temperatureC
        setHeaderImage(url: weather.imageURL)
        
        weatherTableVC.tableView.reloadData()
        
        UIView.animate(withDuration: 0.3) {
            self.weatherTableVC.view.alpha = 1
        }
    }
}


extension WeatherViewController: WeatherTableViewControllerDelegate {
    func didFetchForecastImages() {
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
}

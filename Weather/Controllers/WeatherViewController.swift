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
    
    var city = "Berlin"
    var safeArea: UILayoutGuide!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        safeArea = view.layoutMarginsGuide
        setupTableView()
    }
    
    override func loadView() {
        super.loadView()
        
        NetworkService.shared.fetchWeather(from: city) { result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self.weatherView.cityLabel.text = weather.city
                    self.weatherView.degreesLabel.text = weather.temperatureC
                    self.setImage(url: weather.imageURL)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    private func setupTableView() {
        view.addSubview(weatherView)
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        style()
        layout()
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


extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20 // TODO: Use amount of forecasts or similar
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "TODO"
        
        return cell
    }
}

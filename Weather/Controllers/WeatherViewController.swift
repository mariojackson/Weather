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
    
    var safeArea: UILayoutGuide! // TODO: Why do we have to add the exclamation mark in the view controller?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        safeArea = view.layoutMarginsGuide
        setupTableView()
    }
    
    override func loadView() {
        super.loadView()
        
        NetworkService.shared.fetchWeather(from: "Zurich") { result in // TODO:
            switch result {
            case .success(let weather):
                DispatchQueue.main.async { // TODO: Why are we forced to use this? I thought it would be bad to use this, but that it would still work.
                    self.weatherView.cityLabel.text = weather.city
                    self.weatherView.degreesLabel.text = weather.temperatureC
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    func setupTableView() {
        view.addSubview(weatherView)
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
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

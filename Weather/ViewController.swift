//
//  ViewController.swift
//  Weather
//
//  Created by Mario Jackson on 3/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    let currentWeatherView = CurrentWeatherView(city: "Berlin", degrees: "28")
    
    var safeArea: UILayoutGuide! // TODO: Why do we have to add the exclamation mark in the view controller?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        safeArea = view.layoutMarginsGuide
        setupTableView()
        
        NetworkService.shared.fetchCurrentWeather(from: "Zurich") { result in // TODO: This should be handled in CurrentWeatherView
            switch result {
            case .success(let currentWeather):
                print(currentWeather)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    func setupTableView() {
        view.addSubview(currentWeatherView)
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentWeatherView.heightAnchor.constraint(equalToConstant: 200),
            currentWeatherView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            currentWeatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentWeatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20 // TODO: Use amount of forecasts or similar
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "TODO"
        
        return cell
    }
}

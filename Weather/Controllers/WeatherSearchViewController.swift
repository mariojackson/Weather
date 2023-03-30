//
//  WeatherSearchViewController.swift
//  Weather
//
//  Created by Mario Jackson on 3/21/23.
//

import UIKit

class WeatherSearchViewController: UIViewController {
    let searchView = WeatherSearchView()
    let errorMessageLabel = UILabel()
    let stackView = UIStackView()
    
    private let weatherVC = WeatherViewController()
    
    var city: String? {
        searchView.searchTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        searchView.searchButton.addTarget(self, action: #selector(searchTapped), for: .primaryActionTriggered)
    }
    
    // MARK: - View Configuration
    private func configureViews() {
        view.backgroundColor = .systemBackground
        title = "Search"
        
        configureStackView()
    }
    
    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.addArrangedSubview(searchView)
        stackView.addArrangedSubview(errorMessageLabel)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1)
        ])
    }
    
    private func configureErrorMessageLabel() {
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.isHidden = true
    }
}


// MARK: - Actions
extension WeatherSearchViewController {
    @objc private func searchTapped(sender: UIButton) {
        errorMessageLabel.isHidden = true
        search()
    }
    
    private func addWeatherView() {
        weatherVC.city = city
        
        self.addChild(weatherVC)
        view.addSubview(weatherVC.view)
        
        weatherVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherVC.view.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            weatherVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        weatherVC.didMove(toParent: self)
    }
    
    private func search() {
        guard let city else {
            assertionFailure("City should never be nil")
            return
        }
        
        if city.isEmpty {
            showError(withMessage: "City cannot be blank")
            return
        }
        
        addWeatherView()
    }
    
    private func showError(withMessage message: String) {
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
    }
}

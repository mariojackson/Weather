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
    
    var city: String? {
        searchView.searchTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        searchView.searchButton.addTarget(self, action: #selector(searchTapped), for: .primaryActionTriggered)
    }
}


// MARK: - View Configuration
extension WeatherSearchViewController {
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
    
    private func addWeatherView() {
        guard let city else { return }
        
        let weatherVC = WeatherViewController(city: city)
        
        self.addChild(weatherVC)
        
        weatherVC.view.alpha = 0
        view.addSubview(weatherVC.view)
        UIView.animate(withDuration: 0.3) {
            weatherVC.view.alpha = 1
        }
        
        weatherVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherVC.view.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            weatherVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        weatherVC.didMove(toParent: self)
    }
}


// MARK: - Actions
extension WeatherSearchViewController {
    @objc private func searchTapped(sender: UIButton) {
        errorMessageLabel.isHidden = true
        search()
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
}


// MARK: - Helper Methods
extension WeatherSearchViewController {
    private func showError(withMessage message: String) {
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
    }
}

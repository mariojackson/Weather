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
        
        style()
        layout()
        
        searchView.searchButton.addTarget(self, action: #selector(searchTapped), for: .primaryActionTriggered)
    }
    
    private func style() {
        view.backgroundColor = .systemBackground
        
        title = "Search"
        
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.isHidden = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
    }
    
    private func layout() {
        stackView.addArrangedSubview(searchView)
        stackView.addArrangedSubview(errorMessageLabel)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1)
        ])
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
        
        let weatherVC = WeatherViewController()
        weatherVC.city = city
        
        present(weatherVC, animated: true)
    }
    
    private func showError(withMessage message: String) {
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
    }
}

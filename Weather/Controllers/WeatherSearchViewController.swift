//
//  WeatherSearchViewController.swift
//  Weather
//
//  Created by Mario Jackson on 3/21/23.
//

import UIKit

class WeatherSearchViewController: UIViewController {
    let searchView = WeatherSearchView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
        
        searchView.searchButton.addTarget(self, action: #selector(searchTapped), for: .primaryActionTriggered)
    }
    
    private func style() {
        view.backgroundColor = .systemBackground
    }
    
    private func layout() {
        view.addSubview(searchView)
        
        NSLayoutConstraint.activate([
            searchView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: searchView.trailingAnchor, multiplier: 1)
        ])
    }
    
    @objc private func searchTapped(sender: UIButton) {
        // TODO: Show weather view and provide it the given city
        print("TODO")
    }
}

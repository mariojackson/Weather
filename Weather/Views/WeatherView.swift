//
//  WeatherView.swift
//  Weather
//
//  Created by Mario Jackson on 3/14/23.
//

import UIKit


class WeatherView: UIView {
    
    let cityLabel = UILabel()
    let degreesLabel = UILabel()
    let stackView = UIStackView()
    // TODO: Add image view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        style()
        layout()
    }
    
    init(city: String = "NOT SET", degrees: String = "NOT SET") {
        super.init(frame: .zero)
        
        cityLabel.text = city
        degreesLabel.text = degrees
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension WeatherView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        cityLabel.font = .preferredFont(forTextStyle: .title1)
        degreesLabel.font = .preferredFont(forTextStyle: .title2)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center // TODO: Why won't this work without setting the stack views center x anchor to the views center x anchor?
    }
    
    func layout() {
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(degreesLabel)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            cityLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2)
        ])
    }
}


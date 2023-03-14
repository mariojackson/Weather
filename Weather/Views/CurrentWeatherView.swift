//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Mario Jackson on 3/14/23.
//

import UIKit


class CurrentWeatherView: UIView {
    
    let cityLabel = UILabel()
    let degreeLabel = UILabel()
    let stackView = UIStackView()
    // TODO: Add image view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}


extension CurrentWeatherView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        cityLabel.text = "Berlin"
        cityLabel.font = .preferredFont(forTextStyle: .title1)
        
        degreeLabel.text = "28°"
        degreeLabel.font = .preferredFont(forTextStyle: .title2)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center // TODO: Why won't this work without setting the stack views center x anchor to the views center x anchor?
    }
    
    func layout() {
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(degreeLabel)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            cityLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2)
        ])
    }
}


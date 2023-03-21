//
//  WeatherSearchView.swift
//  Weather
//
//  Created by Mario Jackson on 3/21/23.
//

import UIKit


class WeatherSearchView: UIView {
    
    let stackView = UIStackView()
    let title = UILabel()
    let searchField = UITextField()
    let searchButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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


extension WeatherSearchView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 5
        clipsToBounds = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .preferredFont(forTextStyle: .title1)
        title.text = "Weather"
        title.textAlignment = .center
        
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "City to search..."
        searchField.borderStyle = .roundedRect
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.configuration = .filled()
        searchButton.setTitle("Show", for: [])
        searchButton.tintColor = .black
    }
    
    func layout() {
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(searchField)
        stackView.addArrangedSubview(searchButton)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1)
        ])
        
        addSubview(stackView)
    }
}

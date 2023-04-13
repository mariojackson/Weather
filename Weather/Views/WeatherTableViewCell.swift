//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Mario Jackson on 3/24/23.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    static let identifier = "WeatherCell"
    
    public var forecastDay: ForecastDay?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        
        return stack
    }()
    
    public let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "cloud")
        iv.tintColor = .label
        
        return iv
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = "NOT SET"
        
        return label
    }()
    
    private let maxDegreeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "NOT SET"
        
        return label
    }()
    
    private let minDegreeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "NOT SET"
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.style()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(forecastDay: ForecastDay, withImage image: UIImage?, day: String) {
        self.weatherImageView.image = image ?? self.weatherImageView.image
        self.weatherLabel.text = day
        self.maxDegreeLabel.text = forecastDay.maxDegreeC
        self.minDegreeLabel.text = forecastDay.minDegreeC
        
        self.forecastDay = forecastDay
    }
}


// MARK: - Layout
extension WeatherTableViewCell {
    private func style() {
        minDegreeLabel.textAlignment = .right
        maxDegreeLabel.textAlignment = .right
    }
    
    private func layout() {
        stackView.addArrangedSubview(weatherLabel)
        stackView.addArrangedSubview(weatherImageView)
        stackView.addArrangedSubview(maxDegreeLabel)
        stackView.addArrangedSubview(minDegreeLabel)
        
        self.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            // Stack View
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            // Weather Image
            weatherImageView.widthAnchor.constraint(equalToConstant: 32),
            
            // Max Degree Label
            maxDegreeLabel.widthAnchor.constraint(equalToConstant: 60),
            
            // Min Degree Label
            minDegreeLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}

//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Mario Jackson on 3/24/23.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    static let identifier = "WeatherCell"
    
    private let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "cloud")
        iv.tintColor = .label
        return iv
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = "NOT SET"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(withImage image: UIImage?, label: String) {
        self.weatherImageView.image = image ?? self.weatherImageView.image
        self.weatherLabel.text = label
    }
}


// MARK: - Layout
extension WeatherTableViewCell {
    func layout() {
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(weatherLabel)
        self.contentView.addSubview(weatherImageView)
        
        NSLayoutConstraint.activate([
            weatherLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            weatherLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            weatherLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor, constant: 16),
            
            weatherImageView.heightAnchor.constraint(equalToConstant: 32),
            weatherImageView.widthAnchor.constraint(equalToConstant: 32),
            
            weatherImageView.leadingAnchor.constraint(equalTo: weatherLabel.layoutMarginsGuide.trailingAnchor),
            weatherImageView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor, constant: -16),
            weatherImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}

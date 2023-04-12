//
//  WeatherHeaderView.swift
//  Weather
//
//  Created by Mario Jackson on 4/12/23.
//

import UIKit

class WeatherHeaderView: UIView {
    
    private var stackView: UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }
    
    private var cityLabel: UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        
        return label
    }
    
    private var degreesLabel: UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        
        return label
    }
    
    private var imageView: UIImageView {
        let imageView = UIImageView()
        imageView.frame(forAlignmentRect: CGRect(x: 64, y: 64, width: 64, height: 64))
        
        return imageView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension WeatherHeaderView {
    private func configureView() {
       translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(degreesLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1)
        ])
    }
}

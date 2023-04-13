//
//  WeatherForecastDayController.swift
//  Weather
//
//  Created by Mario Jackson on 4/13/23.
//

import UIKit


class WeatherForecastDayController: UIViewController {
    private var forecastDay: ForecastDay
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = forecastDay.weekday
        
        return label
    }()
    
    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.text = forecastDay.day.condition.text
        
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 128, height: 128))
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var maxDegreesLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.text = "↑ \(forecastDay.maxDegreeC)"
        
        return label
    }()
    
    private lazy var minDegreesLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.text = "↓ \(forecastDay.minDegreeC)"
        
        return label
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        configureView()
    }
    
    init(forecastDay: ForecastDay, image: UIImage) {
        self.forecastDay = forecastDay
        
        super.init(nibName: nil, bundle: nil)
        
        self.imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension WeatherForecastDayController {
    private func configureView() {
        title = forecastDay.weekday
        
        stackView.addArrangedSubview(weekdayLabel)
        stackView.addArrangedSubview(conditionLabel)
        stackView.addArrangedSubview(maxDegreesLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(minDegreesLabel)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 400),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

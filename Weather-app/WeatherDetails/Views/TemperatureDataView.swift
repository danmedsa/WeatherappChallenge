//
//  TemperatureDataView.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import UIKit

class TemperatureDataView: UIStackView {

    struct ViewModel {
        var title: String
        var weather: Weather
        var secondaryWeatherDetail: String?
    }
    
    init(viewModel: ViewModel) {
        super.init(frame: .zero)
        axis = .vertical
        addTitle(text: viewModel.title)
        addMainWeatherData(data: viewModel.weather)
    }
    
    // Not required as Storyboard or XIBs are not being used
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addTitle(text: String) {
        let label = UILabel()
        label.text = text
        addArrangedSubview(label)
    }

    private func addMainWeatherData(data weather: Weather) {
        let weatherDataStackView = UIStackView()
        weatherDataStackView.axis = .horizontal
        weatherDataStackView.spacing = 8
        addArrangedSubview(weatherDataStackView)
        addMainWeatherView(imageName: weather.icon, to: weatherDataStackView)
        addWeatherText(text: weather.main, to: weatherDataStackView)
    }
    
    private func addMainWeatherView(imageName: String, to stackView: UIStackView) {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: imageView, attribute: .height, multiplier: 1, constant: 0),

        ])
        stackView.addArrangedSubview(imageView)
    }
    
    private func addWeatherText(text: String, to stackView: UIStackView) {
        let weatherText = UILabel()
        weatherText.text = text
        stackView.addArrangedSubview(weatherText)
    }
}

//
//  WeatherDetialsView:.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import UIKit

protocol WeatherDetailsViewDelegate: AnyObject {
    func loadImage(code: String) async -> UIImage?
}

class WeatherDetailsView: UIStackView {
    
    private weak var delegate: WeatherDetailsViewDelegate?

    private lazy var title: UILabel = {
        return UILabel()
    }()
    
    private lazy var mainWeatherDataStackView: UIStackView = {
        let weatherDataStackView = UIStackView()
        weatherDataStackView.axis = stackViewAxis
        weatherDataStackView.distribution = .equalSpacing
        weatherDataStackView.alignment = .center
        return weatherDataStackView
    }()
    
    private var stackViewAxis: NSLayoutConstraint.Axis {
        traitCollection.horizontalSizeClass == .compact ? .vertical : .horizontal
    }
    
    private var weatherIcon = UIImageView()
    private var weatherLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private var tempAndFeelsLike = InfoPairView()
    private var tempMinAndMax = InfoPairView()
    private var cloudinessAndVisibility = InfoPairView()
    private var windAndHumidity = InfoPairView()
    private var rain = InfoPairView()
    private var snow = InfoPairView()
    

    struct ViewModel {
        var title: String
        var weather: [Weather]
        var tempAndFeelsLikeVM: InfoPairView.ViewModel
        var tempMinAndMaxVM: InfoPairView.ViewModel
        var cloudinessAndVisibilityVM: InfoPairView.ViewModel
        var windAndHumidityVM: InfoPairView.ViewModel
        var rainVM: InfoPairView.ViewModel
        var snowVM: InfoPairView.ViewModel
    }
    
    init(delegate: WeatherDetailsViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        axis = .vertical
        spacing = 8
        
        addArrangedSubview(title)
        addArrangedSubview(mainWeatherDataStackView)
        addArrangedSubview(tempAndFeelsLike)
        addArrangedSubview(tempMinAndMax)
        addArrangedSubview(cloudinessAndVisibility)
        addArrangedSubview(windAndHumidity)
        addArrangedSubview(rain)
        addArrangedSubview(snow)
        
        mainWeatherDataStackView.addArrangedSubview(weatherIcon)
        mainWeatherDataStackView.addArrangedSubview(weatherLbl)
    }
    
    func configureView(viewModel: ViewModel) {
        title.text = viewModel.title
        weatherLbl.text = viewModel.weather.first?.description ?? ""
        updateImage(iconCode: viewModel.weather.first?.icon ?? "")
        tempAndFeelsLike.configureView(viewModel: viewModel.tempAndFeelsLikeVM)
        tempMinAndMax.configureView(viewModel: viewModel.tempMinAndMaxVM)
        cloudinessAndVisibility.configureView(viewModel: viewModel.cloudinessAndVisibilityVM)
        windAndHumidity.configureView(viewModel: viewModel.windAndHumidityVM)
        rain.configureView(viewModel: viewModel.rainVM)
        snow.configureView(viewModel: viewModel.snowVM)
    }
    
    func setOrientationLayout(size: UIUserInterfaceSizeClass) {
        if size == .regular {
            axis = .horizontal
        }
    }

    // Not required as Storyboard or XIBs are not being used
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addWeatherImageView() {
        mainWeatherDataStackView.addArrangedSubview(weatherIcon)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: weatherIcon, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: weatherIcon, attribute: .width, relatedBy: .lessThanOrEqual, toItem: weatherIcon, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: weatherIcon, attribute: .left, relatedBy: .equal, toItem: mainWeatherDataStackView, attribute: .left, multiplier: 1, constant: 16),
        ])
    }
    
    private func updateImage(iconCode: String) {
        Task(priority: .low) {
            let image = await delegate?.loadImage(code: iconCode)
            weatherIcon.image = image
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mainWeatherDataStackView.axis = stackViewAxis
    }
}

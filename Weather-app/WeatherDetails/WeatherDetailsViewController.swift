//
//  ViewController.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import UIKit

class WeatherDetailsViewController: UIViewController {
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // not needed as Storyboard is not used
    required init?(coder: NSCoder) {
        fatalError("View Controller Should not be used with Storyboard")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        addMainStackView()
        addSearchBar()
        addTemperatureDataView()
        addCouldinessDataView()
        addRainAndSnowData()
        addMainWeatherDataView()
        addWindSpeedAndVisibility()
    }
    
    private func addMainStackView() {
        guard let view else { return }
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: view.safeAreaLayoutGuide, attribute: .top, relatedBy: .equal, toItem: mainStackView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view.safeAreaLayoutGuide, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: mainStackView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: mainStackView, attribute: .left, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: mainStackView, attribute: .right, multiplier: 1, constant: 8),
        ])
    }
    
    private func addSearchBar() {
        let viewModel = SearchBarView.ViewModel(placeholderText: "search City or State in the US")
        let searchBar = SearchBarView(viewModel: viewModel)
        mainStackView.addArrangedSubview(searchBar)
        mainStackView.setCustomSpacing(8,after: searchBar)
    }
    
    private func addTemperatureDataView() {
        let weather = Weather(id: 500, main: "Rain", description: "light rain", icon: "10n")
        let viewModel = TemperatureDataView.ViewModel(title: "Current weather:", weather: weather)
        let tempView = TemperatureDataView(viewModel: viewModel)
        
        mainStackView.addArrangedSubview(tempView)
    }
    
    private func addCouldinessDataView() {
        let cloudinessLbl = makeLabelWithKeyValueText(title: "Cloudiness", int: 30)
        cloudinessLbl.text = "\(cloudinessLbl.text ?? "")%" // TODO: Presenter.getCloudinessText
        mainStackView.addArrangedSubview(cloudinessLbl)
    }
    
    private func addRainAndSnowData() {
        let rain = OWMWeatherVolumeData(oneHour: 0.2, threeHour: nil)
        var rainSubViews: [UIView] = []
        if let oneHourData = rain.oneHour {
            let oneHourLbl = makeLabelWithKeyValueText(title: "1hr", float: oneHourData)
            rainSubViews.append(oneHourLbl)
        }
        
        if let threeHourData = rain.threeHour {
            let threeHourLbl = makeLabelWithKeyValueText(title: "3hr", float: threeHourData)
            rainSubViews.append(threeHourLbl)
        }
        
        if !rainSubViews.isEmpty {
            let title = UILabel()
            title.text = "Rain Data:"
            rainSubViews.insert(title, at: 0)
            let rainStackView = makeDefaultStackView(arrangedViews: rainSubViews, axis: .horizontal)
            rainStackView.distribution = .fillProportionally
            mainStackView.addArrangedSubview(rainStackView)
        }
        
        let snow = OWMWeatherVolumeData(oneHour: nil, threeHour: nil)
        var snowSubviews: [UIView] = []
        if let oneHourData = snow.oneHour {
            let oneHourLbl = makeLabelWithKeyValueText(title: "1hr", float: oneHourData)
            snowSubviews.append(oneHourLbl)
        }
        
        if let threeHourData = snow.threeHour {
            let threeHourLbl = makeLabelWithKeyValueText(title: "3hr", float: threeHourData)
            snowSubviews.append(threeHourLbl)
        }
        
        if !snowSubviews.isEmpty {
            let title = UILabel()
            title.text = "Snow Data:"
            snowSubviews.insert(title, at: 0)
            let snowStackView = makeDefaultStackView(arrangedViews: snowSubviews, axis: .horizontal)
            snowStackView.distribution = .fillProportionally
            mainStackView.addArrangedSubview(snowStackView)
        }
    }
    
    private func addMainWeatherDataView() {
        let data = OWMMainWeatherData(temp: 39.4, feelsLike: 40, tempMin: 29, tempMax: 42, humidity: 68)
        let tempLbl = makeLabelWithKeyValueText(title: "temp", float: data.temp)
        let feelsLikeLbl = makeLabelWithKeyValueText(title: "feels like", float: data.feelsLike)
        let tempMinLbl = makeLabelWithKeyValueText(title: "min", float: data.tempMin)
        let tempMaxLbl = makeLabelWithKeyValueText(title: "max", float: data.tempMax)
        let humidityLbl = makeLabelWithKeyValueText(title: "humidity", int: data.humidity)
        humidityLbl.text = "\(humidityLbl.text ?? "")%" // TODO: Presenter.getHumidityText
        
        let tempStackView = makeDefaultStackView(arrangedViews: [tempLbl, feelsLikeLbl], axis: .horizontal)
        mainStackView.addArrangedSubview(tempStackView)
        
        let tempDetailsStackView = makeDefaultStackView(arrangedViews: [tempMinLbl, tempMaxLbl, humidityLbl], axis: .horizontal)
        mainStackView.addArrangedSubview(tempDetailsStackView)
    }
    
    private func addWindSpeedAndVisibility() {
        let windspeedLbl = makeLabelWithKeyValueText(title: "wind speed", float: 34.5)
        windspeedLbl.text = "\(windspeedLbl.text ?? "") mph" // TODO: presenter.getWindSpeed
        
        let visibilityLbl = makeLabelWithKeyValueText(title: "visibility", int: 1000)
        visibilityLbl.text = "\(visibilityLbl.text ?? "") miles" // TODO: presenter.getvisibility
        
        let stackView = makeDefaultStackView(arrangedViews: [windspeedLbl, visibilityLbl], axis: .horizontal)
        mainStackView.addArrangedSubview(stackView)
    }
    
    
    // MARK: - Helper Funcs
    
    private func makeLabelWithKeyValueText(title: String, int: Int) -> UILabel {
        let label = UILabel()
        label.text = title + ": \(int)"
        return label
    }
    
    private func makeLabelWithKeyValueText(title: String, float: Float) -> UILabel {
        let label = UILabel()
        label.text = title + ": \(float)"
        return label
    }
    
    private func makeDefaultStackView(arrangedViews: [UIView], axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedViews)
        stackView.axis = axis
        stackView.spacing = 8
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
        return stackView
    }
}

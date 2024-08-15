//
//  ViewController.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import UIKit

protocol WeatherDetailsViewControlling: AnyObject {
    var presenter: WeatherDetailsPresenting { get }
}

class WeatherDetailsViewController: UIViewController, WeatherDetailsViewControlling {
    
    private var loadingIndicator = LoadingIndicatorView()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var presenter: WeatherDetailsPresenting
    
    init(presenter: WeatherDetailsPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    // not needed as Storyboard is not used
    required init?(coder: NSCoder) {
        fatalError("View Controller Should not be used with Storyboard")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackgroundColor
        configureView()
    }
    
    private func configureView() {
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
        let viewModel = SearchBarView.ViewModel(placeholderText: presenter.contentProvider.searchBarPlaceholder)
        let searchBar = SearchBarView(viewModel: viewModel)
        searchBar.delegate = self
        mainStackView.addArrangedSubview(searchBar)
        mainStackView.setCustomSpacing(8, after: searchBar)
    }
    
    private func addTemperatureDataView() {
        let weather = Weather(id: 500, main: "Rain", description: "light rain", icon: "10n")
        let viewModel = TemperatureDataView.ViewModel(title: presenter.contentProvider.currentWeatherTitle, weather: weather)
        let tempView = TemperatureDataView(viewModel: viewModel)
        
        mainStackView.addArrangedSubview(tempView)
    }
    
    private func addCouldinessDataView() {
        let cloudinessLbl = makeLabelWithKeyValueText(title: presenter.contentProvider.cloudinessTitle, int: 30)
        cloudinessLbl.text = "\(cloudinessLbl.text ?? "")".asPercentage
        mainStackView.addArrangedSubview(cloudinessLbl)
    }
    
    private func addRainAndSnowData() {
        let rain = OWMWeatherVolumeData(oneHour: 0.2, threeHour: nil)
        var rainSubViews: [UIView] = []
        if let oneHourData = rain.oneHour {
            let oneHourLbl = makeLabelWithKeyValueText(title: presenter.contentProvider.oneHourTitle, float: oneHourData)
            rainSubViews.append(oneHourLbl)
        }
        
        if let threeHourData = rain.threeHour {
            let threeHourLbl = makeLabelWithKeyValueText(title: presenter.contentProvider.threeHourTitle, float: threeHourData)
            rainSubViews.append(threeHourLbl)
        }
        
        if !rainSubViews.isEmpty {
            let title = UILabel()
            title.text = presenter.contentProvider.rainDataTitle.asTitle
            rainSubViews.insert(title, at: 0)
            let rainStackView = makeDefaultStackView(arrangedViews: rainSubViews, axis: .horizontal)
            rainStackView.distribution = .fillProportionally
            mainStackView.addArrangedSubview(rainStackView)
        }
        
        let snow = OWMWeatherVolumeData(oneHour: nil, threeHour: nil)
        var snowSubviews: [UIView] = []
        if let oneHourData = snow.oneHour {
            let oneHourLbl = makeLabelWithKeyValueText(title: presenter.contentProvider.oneHourTitle, float: oneHourData)
            snowSubviews.append(oneHourLbl)
        }
        
        if let threeHourData = snow.threeHour {
            let threeHourLbl = makeLabelWithKeyValueText(title: presenter.contentProvider.threeHourTitle, float: threeHourData)
            snowSubviews.append(threeHourLbl)
        }
        
        if !snowSubviews.isEmpty {
            let title = UILabel()
            title.text = presenter.contentProvider.snowDataTitle.asTitle
            snowSubviews.insert(title, at: 0)
            let snowStackView = makeDefaultStackView(arrangedViews: snowSubviews, axis: .horizontal)
            snowStackView.distribution = .fillProportionally
            mainStackView.addArrangedSubview(snowStackView)
        }
    }
    
    private func addMainWeatherDataView() {
        let tempLbl = makeLabelWithKeyValueText(title: presenter.contentProvider.tempTitle, float: 39.4)
        let feelsLikeLbl = makeLabelWithKeyValueText(title: presenter.contentProvider.feelsLikeTitle, float: 40)
        let tempMinLbl = makeLabelWithKeyValueText(title: presenter.contentProvider.tempMinTitle, float: 34)
        let tempMaxLbl = makeLabelWithKeyValueText(title: presenter.contentProvider.tempMaxTitle, float: 42)
        let humidityLbl = makeLabelWithKeyValueText(title: presenter.contentProvider.humidityTitle, int: 35)
        humidityLbl.text = "\(humidityLbl.text ?? "Unkown")".asPercentage
        
        let tempStackView = makeDefaultStackView(arrangedViews: [tempLbl, feelsLikeLbl], axis: .horizontal)
        mainStackView.addArrangedSubview(tempStackView)
        
        let tempDetailsStackView = makeDefaultStackView(arrangedViews: [tempMinLbl, tempMaxLbl, humidityLbl], axis: .horizontal)
        mainStackView.addArrangedSubview(tempDetailsStackView)
    }
    
    private func addWindSpeedAndVisibility() {
        let windspeedLbl = makeLabelWithKeyValueText(title: presenter.contentProvider.windSpeedTitle, float: 34.5)
        windspeedLbl.text = "\(windspeedLbl.text ?? "") \(presenter.contentProvider.mphText)"
        let visibilityLbl = makeLabelWithKeyValueText(title: presenter.contentProvider.visibilityTitle, int: 1000)
        visibilityLbl.text = "\(visibilityLbl.text ?? "") \(presenter.contentProvider.milesText)"
        
        let stackView = makeDefaultStackView(arrangedViews: [windspeedLbl, visibilityLbl], axis: .horizontal)
        mainStackView.addArrangedSubview(stackView)
    }
    
    
    // MARK: - Helper Funcs
    
    private func makeLabelWithKeyValueText(title: String, int: Int) -> UILabel {
        let label = UILabel()
        label.text = title.asTitle + "\(int)"
        return label
    }
    
    private func makeLabelWithKeyValueText(title: String, float: Float) -> UILabel {
        let label = UILabel()
        label.text = title.asTitle + "\(float)"
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

extension WeatherDetailsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        loadingIndicator.show(in: self)
        Task {
            do {
                try await presenter.fetchWeatherData(location: searchText)
            } catch {
                print(error)
            }
            loadingIndicator.hide()
        }
    }
}

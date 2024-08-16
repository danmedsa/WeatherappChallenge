//
//  ViewController.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import CoreLocation
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
    
    private lazy var weatherDetailsView: WeatherDetailsView = {
        return WeatherDetailsView(delegate: self)
    }()
    
    private var searchBar: UISearchBar?
    
    var presenter: WeatherDetailsPresenting
    private var contentProvider: WeatherDetailsContentProviding {
        presenter.contentProvider
    }
    
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
        addActionBar()
        addMainStackView()
        addSearchBar()
        mainStackView.addArrangedSubview(weatherDetailsView)

        if let location = presenter.location {
            triggerWeatherDataService(location: location)
        }
    }
    
    func triggerWeatherDataService(location: String) {
        loadingIndicator.show(in: self)
        Task {
            do {
                let weatherResponse = try await presenter.fetchWeatherData(location: location)
                configureView(weather: weatherResponse)
            } catch ServiceHandler.Errors.responseError(let serviceError) {
                showErrorAlert(message: serviceError.message)
            } catch OWMServiceProvider.OWMError.locationNotFound(let errorMessage) {
                showErrorAlert(message: errorMessage)
            } catch {
                showErrorAlert(message: error.localizedDescription)
            }
            loadingIndicator.hide()
        }
    }
    
    private func configureView(weather: OWMWeatherResponse) {
        guard weather.weather.first != nil else {
            showErrorAlert(message: presenter.contentProvider.noWeatherDataMessasge)
            return
        }
        configureTemperatureDataView(response: weather)
    }

    private func addMainStackView() {
        guard let view else { return }
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: view.safeAreaLayoutGuide, attribute: .top, relatedBy: .equal, toItem: mainStackView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view.safeAreaLayoutGuide, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: mainStackView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view.safeAreaLayoutGuide, attribute: .left, relatedBy: .equal, toItem: mainStackView, attribute: .left, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: view.safeAreaLayoutGuide, attribute: .right, relatedBy: .equal, toItem: mainStackView, attribute: .right, multiplier: 1, constant: 8),
        ])
    }
    
    private func addActionBar() {
        let farenheit = UILabel()
        farenheit.text = presenter.contentProvider.farenheit
        let celcius = UILabel()
        celcius.text = presenter.contentProvider.celcius
        let toggleSwitch = UISwitch()
        toggleSwitch.isEnabled = true
        let metricStackView =  makeDefaultStackView(arrangedViews: [farenheit, toggleSwitch, celcius], axis: .horizontal)
        let toggleAction = UIAction() { [ weak self] _ in
            guard let self else { return }
            self.presenter.toggleUnits(isFarenheit: !toggleSwitch.isOn)
            if let location = self.presenter.location {
                triggerWeatherDataService(location: location)
            }
        }
        toggleSwitch.addAction(toggleAction, for: .touchUpInside)
        
        let button = UIButton()
        button.setTitle(presenter.contentProvider.locateMeText, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        let action = UIAction() { [weak self] _ in
            self?.searchBar?.text = ""
            self?.presenter.locateMeAction()
        }
        button.addAction(action, for: .touchUpInside)
        
        let actionBarStackView = makeDefaultStackView(arrangedViews: [button, metricStackView], axis: .horizontal)
        mainStackView.addArrangedSubview(actionBarStackView)
    }
    
    private func addSearchBar() {
        let viewModel = SearchBarView.ViewModel(placeholderText: presenter.contentProvider.searchBarPlaceholder, location: presenter.location)
        let searchBar = SearchBarView(viewModel: viewModel)
        searchBar.delegate = self
        self.searchBar = searchBar
        mainStackView.addArrangedSubview(searchBar)
        mainStackView.setCustomSpacing(8, after: searchBar)
    }
    
    private func configureTemperatureDataView(response: OWMWeatherResponse) {
        let viewModel = presenter.makeTemperatureDataViewModel(from: response)
        weatherDetailsView.configureView(viewModel: viewModel)
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
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: presenter.contentProvider.errorAlertTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: presenter.contentProvider.okAlertActionTitle, style: .cancel)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension WeatherDetailsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchBar.resignFirstResponder()
        
        triggerWeatherDataService(location: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: Regex<String>.searchBarRegex, options: []) else { return false }
        return (regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count)) == nil)
    }
}

extension WeatherDetailsViewController: WeatherDetailsViewDelegate {
    func loadImage(code: String) async -> UIImage? {
        let data = await presenter.fetchWeatherImage(with: code)
        return UIImage(data: data)
    }
}

extension WeatherDetailsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let coordinates = Coordinates(latitude: locValue.latitude, longitude: locValue.longitude)
        presenter.stopUpdatingLocation()
        Task {
            let response = try await presenter.fetchWeatherData(coordinates: coordinates)
            configureView(weather: response)
        }
    }
}

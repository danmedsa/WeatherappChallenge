//
//  WeatherDetailsPresenter.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import CoreLocation

protocol WeatherDetailsPresenting {
    var controller: WeatherDetailsViewControlling? { get set }
    var contentProvider: WeatherDetailsContentProviding { get }
    var location: String? { get }
    var locationManager: CLLocationManaging { get }
    
    func fetchWeatherData(location: String) async throws -> OWMWeatherResponse
    func fetchWeatherData(coordinates: Coordinates) async throws -> OWMWeatherResponse
    func makeTemperatureDataViewModel(from response: OWMWeatherResponse) -> WeatherDetailsView.ViewModel
    func fetchWeatherImage(with code: String) async -> Data
    func toggleUnits(isFarenheit: Bool)
    func locateMeAction()
    func stopUpdatingLocation()
}

class WeatherDetailsPresenter: WeatherDetailsPresenting {
    weak var controller: WeatherDetailsViewControlling?
    var contentProvider: WeatherDetailsContentProviding
    var serviceProvider: OWMServiceProviding
    var locationManager: CLLocationManaging
    var userDefaults: UserDefaulting
    private(set) var location: String?
    var unit: Units = .imperial
    
    init(location: String?, contentProvider: WeatherDetailsContentProviding = WeatherDetailsContentProvider(), serviceProvider: OWMServiceProviding, locationManager: CLLocationManaging, userDefaults: UserDefaulting = UserDefaults.standard) {
        self.locationManager = locationManager
        self.contentProvider = contentProvider
        self.serviceProvider = serviceProvider
        self.locationManager = locationManager
        self.userDefaults = userDefaults
        self.location = location
    }
    
    func fetchWeatherData(location: String) async throws -> OWMWeatherResponse {
        self.location = location
        userDefaults.set(location, forKey: Constants.lastLocationKey)
        return try await serviceProvider.makeWeatherDataServiceCall(location: "\(location), US", unit: unit)
    }
    
    func fetchWeatherData(coordinates: Coordinates) async throws -> OWMWeatherResponse {
        return try await serviceProvider.makeWeatherDataServiceCall(coordinates: coordinates, unit: unit)
    }
    
    func makeTemperatureDataViewModel(from response: OWMWeatherResponse) -> WeatherDetailsView.ViewModel {
        let viewModel = WeatherDetailsView.ViewModel(
            title: contentProvider.currentWeatherTitle,
            weather: response.weather,
            tempAndFeelsLikeVM: .init(titleLeft: contentProvider.tempTitle, valueLeft: "\(response.main.temp) \(unit.tempUnit)", titleRight: contentProvider.feelsLikeTitle, valueRight: "\(response.main.feelsLike) \(unit.tempUnit)"),
            tempMinAndMaxVM: .init(titleLeft: contentProvider.tempMinTitle, valueLeft: "\(response.main.tempMin) \(unit.tempUnit)", titleRight: contentProvider.tempMaxTitle, valueRight: "\(response.main.tempMax) \(unit.tempUnit)"),
            cloudinessAndVisibilityVM: .init(titleLeft: contentProvider.cloudinessTitle, valueLeft: "\(response.clouds.percentage)".asPercentage, titleRight: contentProvider.visibilityTitle, valueRight: "\(response.visibility / 1000) \(unit.distanceUnit)"),
            windAndHumidityVM: .init(titleLeft: contentProvider.windSpeedTitle, valueLeft: "\(response.windSpeed) \(unit.distanceUnit)/h", titleRight: contentProvider.humidityTitle, valueRight: "\(response.main.humidity)".asPercentage),
            rainVM: .init(header: contentProvider.rainDataTitle, titleLeft: contentProvider.oneHourTitle, valueLeft: "\(response.rain?.oneHour ?? 0)", titleRight: contentProvider.threeHourTitle, valueRight: "\(response.rain?.threeHour ?? 0)"),
            snowVM: .init(header: contentProvider.snowDataTitle, titleLeft: contentProvider.oneHourTitle, valueLeft: "\(response.snow?.oneHour ?? 0)", titleRight: contentProvider.threeHourTitle, valueRight: "\(response.snow?.threeHour ?? 0)")
        )
        
        return viewModel
    }
    
    func fetchWeatherImage(with code: String) async -> Data {
        let data = try? await serviceProvider.makeWeatherImageServiceCall(imageCode: code)
        return data ?? Data()
    }
    
    func toggleUnits(isFarenheit: Bool) {
        unit = isFarenheit ? .imperial : .metric
    }

    func locateMeAction() {
        locationManager.requestWhenInUseAuthorization()
        Task.detached {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

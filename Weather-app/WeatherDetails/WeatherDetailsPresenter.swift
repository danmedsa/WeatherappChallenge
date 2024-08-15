//
//  WeatherDetailsPresenter.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

protocol WeatherDetailsPresenting {
    var controller: WeatherDetailsViewControlling? { get set }
    var contentProvider: WeatherDetailsContentProviding { get }
    
    func fetchWeatherData(location: String) async throws
}

class WeatherDetailsPresenter: WeatherDetailsPresenting {
    weak var controller: WeatherDetailsViewControlling?
    var contentProvider: WeatherDetailsContentProviding
    var serviceProvider: OWMServiceProviding
    
    init(contentProvider: WeatherDetailsContentProviding, serviceProvider: OWMServiceProviding) {
        self.contentProvider = contentProvider
        self.serviceProvider = serviceProvider
    }
    
    func fetchWeatherData(location: String) async throws {
        try await serviceProvider.makeWeatherDataServiceCall(location: "\(location), US")
    }
    
}

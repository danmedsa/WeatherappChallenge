//
//  WeatherAppScreenBuilder.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import UIKit

struct WeatherAppScreenBuilder {
    static func makeWeatherDetailsScreen() -> UIViewController {
        guard let apiData = Bundle.owmApi else { fatalError( "OpenWeatherMaps API Data not found in OWM-API.plist" ) }
        let serviceProvider = OWMServiceProvider(apiData: apiData)
        let presenter = WeatherDetailsPresenter(contentProvider: WeatherDetailsContentProvider(), serviceProvider: serviceProvider)
        let vc = WeatherDetailsViewController(presenter: presenter)
        return vc
    }
}

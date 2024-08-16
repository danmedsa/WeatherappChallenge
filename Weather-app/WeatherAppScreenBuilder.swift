//
//  WeatherAppScreenBuilder.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import CoreLocation
import UIKit

struct WeatherAppScreenBuilder {
    static func makeWeatherDetailsScreen(location: String?) -> UIViewController {
        guard let apiData = Bundle.owmApi else { fatalError( "OpenWeatherMaps API Data not found in OWM-API.plist" ) }
        let serviceProvider = OWMServiceProvider(apiData: apiData)
        let presenter = WeatherDetailsPresenter(location:location, serviceProvider: serviceProvider, locationManager: CLLocationManager())
        let vc = WeatherDetailsViewController(presenter: presenter)
        presenter.controller = vc
        presenter.locationManager.delegate = vc
        return vc
    }
}

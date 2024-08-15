//
//  WeatherDetailsContentProvider.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

protocol WeatherDetailsContentProviding {
    var searchBarPlaceholder: String { get }
    var currentWeatherTitle: String { get }
    var cloudinessTitle: String { get }
    var rainDataTitle: String { get }
    var snowDataTitle: String { get }
    var tempTitle: String { get }
    var feelsLikeTitle: String { get }
    var tempMinTitle: String { get }
    var tempMaxTitle: String { get }
    var humidityTitle: String { get }
    var windSpeedTitle: String { get }
    var visibilityTitle: String { get }
    var oneHourTitle: String { get }
    var threeHourTitle: String { get }
    var milesText: String { get }
    var kilometersText: String { get }
    var mphText: String { get }
    var kmhText: String { get }
}

struct WeatherDetailsContentProvider: WeatherDetailsContentProviding {
    var searchBarPlaceholder: String { "search City or State in the US" }
    
    var currentWeatherTitle: String { "Current Weather:" }
    
    var cloudinessTitle: String { "cloudiness" }
    
    var rainDataTitle: String { "Rain Data" }
    
    var snowDataTitle: String { "Snow Data" }
    
    var tempTitle: String { "temp" }
    
    var feelsLikeTitle: String { "feels like" }
    
    var tempMinTitle: String { "min" }
    
    var tempMaxTitle: String { "max" }
    
    var humidityTitle: String { "humidity" }
    
    var windSpeedTitle: String { "wind speed" }
    
    var visibilityTitle: String { "visibility" }
    
    var oneHourTitle: String { "1hr" }
    
    var threeHourTitle: String { "3hr" }
    
    var milesText: String { "miles" }
    
    var kilometersText: String { "kilometers" }
    
    var mphText: String { "mph" }
    
    var kmhText: String { "kmh" }
    
    
}

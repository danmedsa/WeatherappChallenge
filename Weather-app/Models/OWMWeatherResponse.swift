//
//  OWMWeatherResponse.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

// Open Weather Map Weather API Response Object

struct OWMWeatherResponse {
    var locationName: String
    var weather: Weather
    var main: OWMMainWeatherData
    var visibility: Int
    var windSpeed: Float
    var rain: OWMWeatherVolumeData?
    var snow: OWMWeatherVolumeData?
    var cloulds: OWMCloudData
}

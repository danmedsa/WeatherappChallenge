//
//  OWMWeatherResponse.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

// Open Weather Map Weather API Response Object

struct OWMWeatherResponse: Decodable {
    var locationName: String
    var weather: [Weather]
    var main: OWMMainWeatherData
    var visibility: Int
    var windSpeed: Float
    var rain: OWMWeatherVolumeData?
    var snow: OWMWeatherVolumeData?
    var clouds: OWMCloudData
    
    enum CodingKeys: String, CodingKey {
        case locationName = "name"
        case weather
        case main
        case visibility
        case windSpeed = "wind"
        case rain
        case snow
        case clouds
    }
    
    enum WindKeys: String, CodingKey {
        case speed
    }
    
    enum CloudsKeys: String, CodingKey {
        case all
    }
    
    // MARK: - Decoder
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        locationName = try container.decode(String.self, forKey: .locationName)
        weather = try container.decode([Weather].self, forKey: .weather)
        main = try container.decode(OWMMainWeatherData.self, forKey: .main)
        visibility = try container.decode(Int.self, forKey: .visibility)
        let windContainer = try container.nestedContainer(keyedBy: WindKeys.self, forKey: .windSpeed)
        windSpeed = try windContainer.decode(Float.self, forKey: .speed)
        rain = try? container.decode(OWMWeatherVolumeData.self, forKey: .rain)
        snow = try? container.decode(OWMWeatherVolumeData.self, forKey: .snow)
        clouds = try container.decode(OWMCloudData.self, forKey: .clouds)
    }
}

//
//  OWMMainWeatherData.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

struct OWMMainWeatherData: Decodable {
    var temp: Float
    var feelsLike: Float
    var tempMin: Float
    var tempMax: Float
    var humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
    
    // MARK: - Decoder
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temp = try container.decode(Float.self, forKey: .temp)
        feelsLike = try container.decode(Float.self, forKey: .feelsLike)
        tempMin = try container.decode(Float.self, forKey: .tempMin)
        tempMax = try container.decode(Float.self, forKey: .tempMax)
        humidity = try container.decode(Int.self, forKey: .humidity)
    }
}

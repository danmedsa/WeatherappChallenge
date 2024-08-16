//
//  MockServiceProvider.swift
//  Weather-appTests
//
//  Created by Daniel Medina Sada on 8/16/24.
//

import Foundation
@testable import Weather_app

class MockServiceProvider: OWMServiceProviding {
    var throwsError: Error?
    
    func makeWeatherDataServiceCall(location: String, unit: Weather_app.Units) async throws -> Weather_app.OWMWeatherResponse {
        if let error = throwsError {
            throw error
        }
        
        let data = Data(weatherResponse.utf8)
        return try! JSONDecoder().decode(OWMWeatherResponse.self, from: data)
    }
    
    func makeWeatherDataServiceCall(coordinates: Weather_app.Coordinates, unit: Weather_app.Units) async throws -> Weather_app.OWMWeatherResponse {
        if let error = throwsError {
            throw error
        }
        
        let data = Data(weatherResponse.utf8)
        return try! JSONDecoder().decode(OWMWeatherResponse.self, from: data)
    }
    
    func makeWeatherImageServiceCall(imageCode: String) async throws -> Data {
        if let error = throwsError {
            throw error
        }
        
        let response = "ImageData"

        return Data(response.utf8)
    }
}

extension MockServiceProvider {
    var weatherResponse: String {
return """
{
  "coord": {
    "lon": -96.7969,
    "lat": 32.7766
  },
  "weather": [
    {
      "id": 800,
      "main": "Clear",
      "description": "clear sky",
      "icon": "01d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 95.74,
    "feels_like": 108.34,
    "temp_min": 93.24,
    "temp_max": 98.17,
    "pressure": 1015,
    "humidity": 52,
    "sea_level": 1015,
    "grnd_level": 997
  },
  "visibility": 10000,
  "wind": {
    "speed": 10.36,
    "deg": 210
  },
  "clouds": {
    "all": 0
  },
  "dt": 1723827362,
  "sys": {
    "type": 2,
    "id": 2075302,
    "country": "US",
    "sunrise": 1723809106,
    "sunset": 1723857073
  },
  "timezone": -18000,
  "id": 4684888,
  "name": "Plano",
  "cod": 200
}
"""

    }
}

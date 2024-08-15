//
//  OWMServiceProvider.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

protocol OWMServiceProviding {
    func makeWeatherDataServiceCall(location: String) async throws -> OWMWeatherResponse
}

struct OWMServiceProvider: OWMServiceProviding {
    enum OWMError: Error {
        case invalidURL
        case locationNotFound(String)
    }
    
    private var apiData: APIData
    private var serviceHandler: ServiceHandling
    
    init(session: URLSessionAPI = URLSession.shared, apiData: APIData) {
        self.serviceHandler = ServiceHandler(session: session)
        self.apiData = apiData
    }
    
    private func makeGeoCoderServiceCall(location: String) async throws -> [OWMGeoCodingResponse] {
        guard let url = URL(string: "https://\(apiData.url)/geo/1.0/direct") else { throw OWMError.invalidURL }
        var request = URLRequest(url: url)
        let location = URLQueryItem(name: "q", value: location)
        let limit = URLQueryItem(name: "limit", value: "1")
        let apiKey = URLQueryItem(name: "appid", value: apiData.apiKey)
        request.url?.append(queryItems: [location, limit, apiKey])
        let (geocoding, _) = try await serviceHandler.makeServiceCall(for: request, type: [OWMGeoCodingResponse].self)
        
        return geocoding
    }
    
    func makeWeatherDataServiceCall(location: String) async throws -> OWMWeatherResponse {
        guard let geocoding = try await makeGeoCoderServiceCall(location: location).first else { throw OWMError.locationNotFound(location) }

        guard let url = URL(string: "https://\(apiData.url)/data/2.5/weather") else { throw OWMError.invalidURL }
        var request = URLRequest(url: url)
        let lat = URLQueryItem(name: "lat", value: "\(geocoding.coordinates.latitude)")
        let lon = URLQueryItem(name: "lon", value: "\(geocoding.coordinates.longitude)")
        let apiKey = URLQueryItem(name: "appid", value: apiData.apiKey)
        request.url?.append(queryItems: [lat, lon, apiKey])
        let (weather, _) = try await serviceHandler.makeServiceCall(for: request, type: OWMWeatherResponse.self)
        
        return weather
    }
}

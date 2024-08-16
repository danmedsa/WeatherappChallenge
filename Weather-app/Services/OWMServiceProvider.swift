//
//  OWMServiceProvider.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

protocol OWMServiceProviding {
    func makeWeatherDataServiceCall(location: String, unit: Units) async throws -> OWMWeatherResponse
    func makeWeatherDataServiceCall(coordinates: Coordinates, unit: Units) async throws -> OWMWeatherResponse
    func makeWeatherImageServiceCall(imageCode: String) async throws -> Data
}

struct OWMServiceProvider: OWMServiceProviding, Caching {
    enum OWMError: Error {
        case invalidURL
        case locationNotFound(String)
    }
    
    private var apiData: APIData
    private var serviceHandler: ServiceHandling
    var fileManager: FileManaging
    
    init(session: URLSessionAPI = URLSession.shared, apiData: APIData, fileManager: FileManaging = FileManager.default) {
        self.serviceHandler = ServiceHandler(session: session)
        self.apiData = apiData
        self.fileManager = fileManager
    }
    
    private func makeGeoCoderServiceCall(location: String) async throws -> [OWMGeoCodingResponse] {
        guard let url = URL(string: "https://api.\(apiData.url)/geo/1.0/direct") else { throw OWMError.invalidURL }
        var request = URLRequest(url: url)
        let location = URLQueryItem(name: "q", value: location)
        let limit = URLQueryItem(name: "limit", value: "1")
        let apiKey = URLQueryItem(name: "appid", value: apiData.apiKey)
        request.url?.append(queryItems: [location, limit, apiKey])
        let (geocoding, _) = try await serviceHandler.makeServiceCall(for: request, type: [OWMGeoCodingResponse].self)
        
        return geocoding
    }
    
    func makeWeatherDataServiceCall(location: String, unit: Units) async throws -> OWMWeatherResponse {
        guard let geocoding = try await makeGeoCoderServiceCall(location: location).first else { throw OWMError.locationNotFound("\(location) Not Data Found") }
        guard let url = URL(string: "https://api.\(apiData.url)/data/2.5/weather") else { throw OWMError.invalidURL }
        
        return try await makeWeatherDataServiceCall(coordinates: geocoding.coordinates, unit: unit)
    }
    
    func makeWeatherDataServiceCall(coordinates: Coordinates, unit: Units) async throws -> OWMWeatherResponse {
        guard let url = URL(string: "https://api.\(apiData.url)/data/2.5/weather") else { throw OWMError.invalidURL }
        var request = URLRequest(url: url)
        let lat = URLQueryItem(name: "lat", value: "\(coordinates.latitude)")
        let lon = URLQueryItem(name: "lon", value: "\(coordinates.longitude)")
        let apiKey = URLQueryItem(name: "appid", value: apiData.apiKey)
        let units = URLQueryItem(name: "units", value: unit.rawValue)
        request.url?.append(queryItems: [lat, lon, apiKey, units])
        let (weather, _) = try await serviceHandler.makeServiceCall(for: request, type: OWMWeatherResponse.self)
        
        return weather
    }
    
    func makeWeatherImageServiceCall(imageCode: String) async throws -> Data {
        let imageFileName = "\(imageCode)@2x.png"
        guard let imagePath = URL(string: imageFileName) else { throw OWMError.invalidURL }
        if let imageData = cachedImage(from: imagePath) {
            return imageData
        }
        
        guard let url = URL(string: "https://www.\(apiData.url)/img/wn/\(imageFileName)") else { return  Data() }
        let request = URLRequest(url: url)
        let (data, _) = try await serviceHandler.makeDataServiceCall(for: request)
        cacheImage(data, from: imagePath)
        return data
        
    }
}

//
//  OWMGeoCodingResponse.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

struct OWMGeoCodingResponse: Decodable {
    var coordinates: Coordinates
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
    // MARK: - Decoder
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinates = Coordinates(latitude: latitude, longitude: longitude)
    }
}

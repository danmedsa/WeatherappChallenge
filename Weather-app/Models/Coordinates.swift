//
//  Coordinates.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

struct Coordinates: Decodable {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lon"
        }
}

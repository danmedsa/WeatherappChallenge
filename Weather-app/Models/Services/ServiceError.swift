//
//  OWMServiceError.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

struct ServiceError: Decodable {
    var cod: Int
    var message: String
}

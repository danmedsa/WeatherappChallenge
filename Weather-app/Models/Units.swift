//
//  Units.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

enum Units: String {
    case imperial
    case metric
    
    var distanceUnit: String { self == .imperial ? "mi" : "km"}
    var tempUnit: String { self == .imperial ? "F" : "C"}
}

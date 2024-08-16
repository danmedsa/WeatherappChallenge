//
//  CLLocationManager.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/16/24.
//

import CoreLocation

protocol CLLocationManaging {
    var delegate: CLLocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

extension CLLocationManager: CLLocationManaging {}

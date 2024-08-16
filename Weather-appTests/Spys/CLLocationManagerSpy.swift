//
//  CLLocationManagerSpy.swift
//  Weather-appTests
//
//  Created by Daniel Medina Sada on 8/16/24.
//

import CoreLocation
@testable import Weather_app

class LocationManagerSpy: CLLocationManaging {    
    var delegate: CLLocationManagerDelegate?
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers
    enum Actions {
        case startUpdateLocation
        case stopUpadteLocation
        case requestWhenInUseAuth
    }
    
    var actions: [Actions] = []
    
    func requestWhenInUseAuthorization() {
        actions.append(.requestWhenInUseAuth)
    }
    
    func startUpdatingLocation() {
        actions.append(.startUpdateLocation)
    }
    
    func stopUpdatingLocation() {
        actions.append(.stopUpadteLocation)
    }
}

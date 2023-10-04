//
//  LocationManager.swift
//  Weather
//
//  Created by jonathan saville on 04/10/2023.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject {
    
    @Published var authorized: Bool = false
    
    static let shared = LocationManager()
    private let clLocationManager = CLLocationManager()
    
    override private init() {
        super.init()
        clLocationManager.delegate = self
    }
    
    func requestAuthorizationIfRequired() {
        clLocationManager.requestWhenInUseAuthorization()
    }

    func getCurrentLocation(withName name: String) -> Location? {

        switch clLocationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            guard let currentLocation = clLocationManager.location else { return nil }
            return Location(coordinates: currentLocation.coordinate, name: name)
        default:
            return nil
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
 
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            authorized = true
        default:
            authorized = false
        }
    }
}


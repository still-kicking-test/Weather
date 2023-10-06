//
//  LocationManager.swift
//  Weather
//
//  Created by jonathan saville on 04/10/2023.
//

import Foundation
import Combine
import CoreLocation

protocol LocationManagerProtocol {
    // We must synthesize 'authorized' as it defined in a protocol
    var authorized: Bool { get }
    var authorizedPublished: Published<Bool> { get }
    var authorizedPublisher: Published<Bool>.Publisher { get }

    func requestAuthorizationIfRequired()
    func getCurrentLocation(withName name: String) -> Location?
}

class LocationManager: NSObject, LocationManagerProtocol {
    @Published var authorized: Bool = false
    var authorizedPublished: Published<Bool> { _authorized }
    var authorizedPublisher: Published<Bool>.Publisher { $authorized }

    private let clLocationManager = CLLocationManager()
    
    override init() {
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


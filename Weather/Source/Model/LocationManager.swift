//
//  LocationManager.swift
//  Weather
//
//  Created by jonathan saville on 04/10/2023.
//

import Foundation
import Combine
import CoreLocation
import WeatherNetworkingKit

protocol LocationManagerProtocol {
    var showVideo: Bool { get set }
    var showCurrentLocation: Bool { get set }
    
    func requestAuthorizationIfRequired()
    func getCurrentLocation(withName name: String) -> Location?
    
    // We must synthesize @Published properties as they are defined in a protocol
    var authorized: Bool { get }
    var authorizedPublisher: Published<Bool>.Publisher { get }
}

class LocationManager: NSObject, LocationManagerProtocol {

    private enum Keys {
        static let showVideo = "showVideo"
        static let showCurrentLocation = "showCurrentLocation"
    }

    @Published var authorized: Bool = false
    var authorizedPublisher: Published<Bool>.Publisher { $authorized }
    
    var showVideo: Bool {
        didSet { defaults.set(showVideo, forKey: Keys.showVideo) }
    }

    var showCurrentLocation: Bool = false {
        didSet { defaults.set(showCurrentLocation, forKey: Keys.showCurrentLocation) }
    }

    private let clLocationManager = CLLocationManager()
    private var defaults = UserDefaults.standard

    override init() {
        showVideo = defaults.object(forKey: Keys.showVideo) as? Bool ?? false
        showCurrentLocation = defaults.object(forKey: Keys.showCurrentLocation) as? Bool ?? false
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

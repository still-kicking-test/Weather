//
//  MockLocationManager.swift
//  Weather
//
//  Created by jonathan saville on 05/10/2023.
//

import Foundation
import CoreLocation
import Combine
import WeatherNetworkingKit

class MockLocationManager: NSObject, LocationManagerProtocol {

    @Published var authorized: Bool = true
    var authorizedPublisher: Published<Bool>.Publisher { $authorized }

    @Published var showVideo: Bool = false
    var showVideoPublisher: Published<Bool>.Publisher { $showVideo }

    @Published var showCurrentLocation: Bool = false
    var showCurrentLocationPublisher: Published<Bool>.Publisher { $showCurrentLocation }

    // When mocked, this must match with the mocked json filename for current location "OneCall(52.656,0.486).json"
    var currentCoordinates = CLLocationCoordinate2D(latitude:52.656, longitude: 0.486)
    
    func requestAuthorizationIfRequired() {
    }

    func getCurrentLocation(withName name: String) -> Location? {
        Location(coordinates: currentCoordinates, name: name)
    }
}

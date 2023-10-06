//
//  MockLocationManager.swift
//  Weather
//
//  Created by jonathan saville on 05/10/2023.
//

import Foundation
import CoreLocation
import Combine

class MockLocationManager: NSObject, LocationManagerProtocol {
    
    // We must synthesize 'authorized' as it defined in a protocol
    @Published var authorized: Bool = true
    var authorizedPublished: Published<Bool> { _authorized }
    var authorizedPublisher: Published<Bool>.Publisher { $authorized }

    // if mocked, this must match with the mocked json filename for current location "OneCall(52.656,0.486).json"
    var currentCoordinates = CLLocationCoordinate2D(latitude:52.656, longitude: 0.486)
    
    func requestAuthorizationIfRequired() {
    }

    func getCurrentLocation(withName name: String) -> Location? {
        Location(coordinates: currentCoordinates, name: name)
    }
}

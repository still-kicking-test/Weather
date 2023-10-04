//
//  Location.swift
//  Weather
//
//  Created by jonathan saville on 03/10/2023.
//

import Foundation
import CoreLocation

class Location {

    var coordinates: Coordinates
    var name: String
    var state: String
    var country: String

    init(coordinates: CLLocationCoordinate2D,
         name: String,
         country: String = "",
         state: String = "") {
        self.coordinates = (Decimal(coordinates.latitude), Decimal(coordinates.longitude))
        self.country = country
        self.name = name
        self.state = state
    }
    
    init(from cdLocation: CDLocation) {
        country = cdLocation.country
        coordinates = (cdLocation.latitude as Decimal, cdLocation.longitude as Decimal)
        name = cdLocation.name
        state = cdLocation.state
    }
}

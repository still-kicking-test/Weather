//
//  Forecast.swift
//  Weather
//
//  Created by jonathan saville on 04/09/2023.
//

import Foundation

struct Forecast {
    var location: Location?
    let daily: [DailyForecast]
    
    /// When loading forecast information from the API service, only the coords are supplied, not the location name, etc. So we have to be able to inject these - we do that by matching the
    /// returned coordinates with those in the locations used in the intial request. Sounds straightforward, but unfortunately the API does not necessarily return exactly the same coordinates
    /// as was requested - some precision is lost, for some reason. Three decimal places seem OK, however, so we restrict the match to just those three decimal places.
    mutating func loadLocation(with coords: Coordinates,
                               from locations: [Location]) {
        let places = 3
        let latitude = coords.latitude.rounded(places)
        let longitude = coords.longitude.rounded(places)
        
        self.location = locations.first{
            latitude == $0.coordinates.latitude.rounded(places) &&
            longitude == $0.coordinates.longitude.rounded(places)
        }
    }
}

struct DailyForecast {
    let date: Date
    let sunrise: Int
    let sunset: Int
    let pressure: Int
    let humidity: Int
    let windSpeed: Decimal
    let windDirection: Int
    let displayable: [DisplayableForecast]
    let windGust: Decimal
    let temperature: TemperatureForecast
}

struct TemperatureForecast {
    let day: Decimal
    let min: Decimal
    let max: Decimal
    let night: Decimal
    let eve: Decimal
    let morn: Decimal
}

struct DisplayableForecast {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

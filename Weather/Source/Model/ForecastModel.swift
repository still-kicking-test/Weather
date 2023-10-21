//
//  ForecastModel.swift
//  Weather
//
//  Created by jonathan saville on 21/10/2023.
//

import Foundation
import WeatherNetworkingKit

final class ForecastModel: ObservableObject {
    @Published var day = 0
    let location: Location
    let forecast: Forecast
    
    init(location: Location,
         forecast: Forecast,
         day: Int = 0) {
        self.location = location
        self.forecast = forecast
        self.day = day
    }
}

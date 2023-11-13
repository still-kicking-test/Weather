//
//  HourlyForecastsView.swift
//  Weather
//
//  Created by jonathan saville on 09/11/2023.
//

import SwiftUI
import CoreLocation
import WeatherNetworkingKit

enum HourlyContentType {
    case wind
    case multiple(FullForecastView.SelectorState)
}

struct HourlyForecastsView: View {
    
    let forecast: Forecast
    let contentType: HourlyContentType
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            let timezoneOffset = forecast.timezoneOffset
            
            ForEach(Array(forecast.hourly.enumerated()), id: \.offset) { index, hourlyForecast in
                let width = (UIScreen.main.bounds.width - 16) / 6
                var height: CGFloat {switch contentType { case .multiple: return HourForecastMultipleView.preferredHeight; case .wind: return HourForecastWindView.preferredHeight }}
                let isFirstForecast = forecast.hourly.first?.id == hourlyForecast.id
                let isLastForecast = forecast.hourly.last?.id == hourlyForecast.id

                HStack(spacing: 0) {

                    if hourlyForecast.isFirstForecastOfDay && !isFirstForecast {
                        HourForecastSeparatorView(day: hourlyForecast.date.shortDayOfWeek(timezoneOffset) ?? "-")
                            .frame(width: width, height: height)
                     }
                    
                    switch contentType {
                    case .multiple(let state):
                        HourForecastMultipleView(hourlyForecast: hourlyForecast,
                                                 timezoneOffset: timezoneOffset,
                                                 selectorState: state)
                        .frame(width: width, height: height)
                        .padding(.trailing, isLastForecast ? 28 : 0)
                        
                    case .wind:
                        HourForecastWindView(hourlyForecast: hourlyForecast,
                                             timezoneOffset: timezoneOffset)
                        .frame(width: width, height: height)
                        .padding(.trailing, isLastForecast ? 28 : 0)
                    }
                }
            }
        }
    }
}

struct HourlyForecastsView_Previews: PreviewProvider {
    static let location = Location(coordinates: CLLocationCoordinate2D(latitude: 41.8933203, longitude: 12.4829321), name: "Rome (Lazio)")
    static var forecast: Forecast = try! MockAPIService().getForecast(for: location.coordinates, from: [location])
    
    static var previews: some View {
        HourlyForecastsView(forecast: forecast, contentType: .multiple(.precipitation))
            .background(.gray)
        .preferredColorScheme(.dark)
   }
}
